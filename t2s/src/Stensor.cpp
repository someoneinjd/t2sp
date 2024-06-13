/*******************************************************************************
* Copyright 2021 Intel Corporation
*
* Licensed under the BSD-2-Clause Plus Patent License (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* https://opensource.org/licenses/BSDplusPatent
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions
* and limitations under the License.
*
*
* SPDX-License-Identifier: BSD-2-Clause-Patent
*******************************************************************************/
#include "./DebugPrint.h"
#include "./BuildCallRelation.h"
#include "./PreprocessBeforeLower.h"
#include "./SliceExprTree.h"
#include "./Stensor.h"
#include "./Utilities.h"

namespace Halide {

using namespace Internal;
using std::vector;
using std::map;
using std::string;
using std::set;

// A chain of stensors
class Schain {
public:
    bool is_output;                     // Is this chain for output? An output chain needs different primitives
    bool write_to_host;
    // Starting point(s) of the chain
    Func outf;                          // Valid only if is_output is true. An output chain starts from a function
    vector<ImageParam> imp;             // Valid only if is_output is false. The image params (i.e. tensors), if any, that start an input chain.
    vector<Expr> starting_exprs;        // Valid only if is_output is false. The expressions, if any, that start an input chain. These expressions usually load tensor data, or create fake data (like padding zeros)
    Func control_ure;                   // The above outf, imp or starting_exprs, belongs to a group of merged UREs. This is the control URE of the group.
    vector<Var> free_vars;              // Variables appeared in the definition of the control URE
    map<string, set<string>> used_vars; // From image param to its indices.
    vector<set<string>> expr_used_vars; // For each starting expression, the variables used in it
    vector<Stensor> stensors;           // Stensors in the chain.

    int var_index(Var v) {
        for (size_t i = 0; i < free_vars.size(); i++) {
            if (v.same_as(free_vars[i]))
                return i;
        }
        return -1;
    }

    bool exists(const vector<Var> &vars) {
        for (const auto &v : vars) {
            if (var_index(v) == -1) {
                return false;
            }
        }
        return true;
    }

    bool exists(Var v) {
        return this->exists(vector<Var>{v});
    }

    vector<VarOrRVar> find_reuse_vars(const set<string> &used_vars, Var scope) {
        vector<VarOrRVar> reuse_vars;
        for (const auto &v : free_vars) {
            if (v.same_as(scope)) {
                break;
            }
            if (used_vars.count(v.name()) == 0) {
                reuse_vars.push_back(v);
            }
        }
        return reuse_vars;
    }

    // Find the first var below/above the given var v whose extent is not 1
    Var find_non_unit_var(Var v, bool above = true) {
        size_t j = var_index(v);
        while (j > 0 && j < free_vars.size()) {
            auto bound = control_ure.function().get_bounds(free_vars[j].name());
            if (!is_one(bound.second)) break;
            j = above ? j + 1 : j - 1;
        }
        return free_vars[j];
    }
};

// All the chains of stensors
vector<Schain> schains;

Stensor &Stensor::scope(Var v) {
    v_scope = v;
    return *this;
}

Stensor &Stensor::banks(const vector<Var> &v) {
    if (v.empty()) {
        // By default, this stensor will output a scalar each time.
        return *this;
    }
    v_banks = v;
    return *this;
}

Stensor &Stensor::out(const vector<Var> &v) {
    if (v.empty()) {
        // By default, this stensor will output a scalar each time.
        return *this;
    }
    v_outs = v;
    return *this;
}

Stensor &Stensor::apply_transform(const std::vector<Expr> &exprs) {
    if (exprs.empty())
        return *this;
    std::copy(exprs.begin(), exprs.end(), back_inserter(operations));
    return *this;
}

Stensor &Stensor::operator()(const vector<Expr> &d) {
    if (d.empty()) {
        // By default, this stensor will use the original layout.
        return *this;
    }
    dims = d;
    return *this;
}

Stensor &Stensor::operator>>(Stensor &s) {
    int c = this->schain_idx;
    internal_assert(c >= 0);
    s.schain_idx = c;
    schains[c].stensors.push_back(s);
    return schains[c].stensors.back();
}

Stensor &operator>>(const vector<ImageParam> &im, Stensor &s) {
    Schain tmp;
    s.schain_idx = schains.size();
    tmp.is_output = false;
    tmp.write_to_host = false;
    tmp.imp = im;
    tmp.stensors.push_back(s);
    schains.push_back(std::move(tmp));
    return schains.back().stensors.back();
}

Stensor &operator>>(const ImageParam &im, Stensor &s) {
    return vector<ImageParam>{im} >> s;
}

Stensor &operator>>(const vector<Expr> &e, Stensor &s) {
    Schain tmp;
    s.schain_idx = schains.size();
    tmp.is_output = false;
    tmp.write_to_host = false;
    tmp.starting_exprs = e;
    tmp.stensors.push_back(s);
    schains.push_back(std::move(tmp));
    return schains.back().stensors.back();
}

Stensor &operator>>(const Expr &e, Stensor &s) {
    return vector<Expr>{e} >> s;
}

Stensor &operator>>(Func &f, Stensor &s) {
    Schain tmp;
    s.schain_idx = schains.size();
    tmp.is_output = true;
    tmp.outf = f;
    tmp.stensors.push_back(s);
    schains.push_back(std::move(tmp));
    return schains.back().stensors.back();
}

struct FindVars
{
    // Find variables appeared in the arguments of inputs
    class FindUsedVars : public IRVisitor
    {
        string image_param;
    public:
        using IRVisitor::visit;
        map<string, std::set<string>> used_vars; // From image param to vars used in its indices. ASSUMPTION: only one reference to an image param is allowed in a T2S specification.

        void visit(const Variable *op) override {
            if (!image_param.empty()) {
                used_vars[image_param].insert(op->name);
            }
        }

        void visit(const Call *op) override {
            if (ends_with(op->name, "_im")) {
                image_param = remove_postfix(op->name, "_im");
                user_assert(used_vars.find(image_param) == used_vars.end()) << "Error: ImageParam " << image_param << " is referenced more than once.";
                for (size_t i = 0; i < op->args.size(); i++) {
                    op->args[i].accept(this);
                }
                image_param.clear();
            } else if (op->is_extern()) {
                for (size_t i = 0; i < op->args.size(); i++) {
                    op->args[i]->accept(this);
                }
            }
        }
    } fuv;

    class FindExprUsedVars : public IRVisitor {
        using IRVisitor::visit;
    public:
        set<string> vars;

        void visit(const Variable *op) override {
            vars.insert(op->name);
        }
    };

    Func control_ure_of_func(const map<string, Func> &env, const Func &func) {
        for (const auto &entry : env) {
            const Func& f = entry.second;
            if (f.function().has_merged_defs()) {
                for (const auto &name : f.function().merged_func_names()) {
                    if (func.name() == name)
                        return std::move(Func(f));
                }
            }
        }
        // If no control URE, the func controls itself
        return func;
    }

    struct ImageParamReferencesInAFunc {
        Func func; // The function that refers image params. Only one reference of each image param is allowed in an entire T2S specification.
        map<string, set<string>> used_vars; // Map from image param to variables used in its subscripts.
    };

    // Find out which function references which image param, and the variables used in referencing an image param
    void find_image_param_references(const map<string, Func> &env, vector<ImageParamReferencesInAFunc> &references) {
        vector<string> visited_image_params;
        for (const auto &entry : env) {
            const Func& f = entry.second;
            fuv.used_vars.clear();
            f.value().accept(&fuv);
            if (!fuv.used_vars.empty()) {
                ImageParamReferencesInAFunc reference;
                reference.func = f;
                reference.used_vars = fuv.used_vars;
                references.push_back(reference);
                for (const auto &v : reference.used_vars) {
                    user_assert(std::find(visited_image_params.begin(), visited_image_params.end(), v.first) == visited_image_params.end()) << "Error: ImageParam " << v.first << " is referenced more than once.";
                    visited_image_params.push_back(v.first);
                }
            }
        }
    }

    FindVars(const map<string, Func> &env) {
        // Find references of image params
        vector<ImageParamReferencesInAFunc> references;
        find_image_param_references(env, references);

        // Find control_ure, free_vars and used_vars for each stensor chain
        for (auto &chain : schains) {
            if (chain.is_output) {
                chain.control_ure = control_ure_of_func(env, chain.outf);
            } else {
                // An input stensor chain starts either with an ImageParam or an expression, but not both
                internal_assert( chain.imp.empty() ||  chain.starting_exprs.empty());
                internal_assert(!chain.imp.empty() || !chain.starting_exprs.empty());
                if (!chain.imp.empty()) {
                    // The input chain starts with image params
                    for (const auto &i : chain.imp) {
                        auto image_param = ends_with(i.name(), "_im") ? remove_postfix(i.name(), "_im") : i.name();
                        for (const auto &refs_in_a_func : references) {
                            for (const auto &ref : refs_in_a_func.used_vars) {
                                if (image_param == ref.first) {
                                    Func control_ure = control_ure_of_func(env, refs_in_a_func.func);
                                    user_assert(!chain.control_ure.defined() or chain.control_ure.function().name() == control_ure.function().name()) << "Error: ImageParams " << to_string(chain.imp) << " are not from the same group of merged UREs";
                                    chain.control_ure = control_ure;
                                    for (const auto &d : control_ure.function().definition().schedule().dims())
                                        chain.free_vars.push_back(d.var);
                                }
                            }
                        }
                    }
                } else {
                    // The input chain starts with expressions. Find out which function's definition uses which expression
                    for (auto &expr : chain.starting_exprs) {
                        bool found = false;
                        for (const auto &entry : env) {
                            const Func& func = entry.second;
                            vector<Expr> values = func.values().as_vector();
                            for (auto value : values) {
                                SliceExprTree slicer("", expr, "Looking for expression " + to_string(expr) + "in Func " + func.name());
                                value.accept(&slicer);
                                if (slicer.matched_operand.defined()) {
                                    // Function contains the expression. Our assumption is that this expression can be contained in one and only one such function.
                                    found = true;
                                    Func control_ure = control_ure_of_func(env, func);
                                    user_assert(!chain.control_ure.defined() or chain.control_ure.function().name() == control_ure.function().name()) << "Error: Expressions " << to_string<Expr>(chain.starting_exprs) << " are not from the same group of merged UREs";
                                    chain.control_ure = control_ure;

                                    // Find variables referenced by this expression
                                    FindExprUsedVars finder;
                                    expr.accept(&finder);
                                    chain.expr_used_vars.push_back(std::move(finder.vars));

                                    // Record the loop dimensions of the control URE.
                                    for (const auto &d : control_ure.function().definition().schedule().dims()) {
                                        chain.free_vars.push_back(d.var);
                                    }
                                    break;
                                }
                            }
                            if (found) break;
                        }
                        user_assert(found) << "Expression " + to_string(expr) + " starts an input chain but it is not contained in any function/URE\n";
                    }
                }
            }
        }
    }
};

// We assume an output function always follows such a pattern:
// Out(...) = select(cond, Z(...)),
// in this case, we find and set func_name as Z
class FindProducerForOutput : public IRVisitor {
    const map<string, Func> env;
public:
    using IRVisitor::visit;
    Func producer;

    void visit(const Select *op) override {
        if (!op->false_value.defined()) {
            auto call = op->true_value.as<Call>();
            internal_assert(call);
            if (call->call_type == Call::CallType::Halide) {
                producer = env.at(call->name);
            }
        }
    }

    FindProducerForOutput(const map<string, Func> &_e)
        : env(_e) {}
};


class RealizeOnFPGA
{
    vector<Var> output_array_dims;
    FindVars &fv;
    FindProducerForOutput &fpo;

    vector<Func> isolate_producer(Schain &c) {
        if (c.stensors[0].position != HOST) {
            // The device stensors needs serialized inputs
            // If the host stensor is not specified, we automatically generate it
            string name = "";
            for (const auto &chain_imp : c.imp)
                name += chain_imp.name() + "_";
            string host_name = name + "serializer";
            Stensor s_host(host_name);
            s_host.schain_idx = c.stensors[0].schain_idx;
            c.stensors.insert(c.stensors.begin(), s_host);
        }
        std::copy(c.imp.begin(), c.imp.end(), back_inserter(c.stensors[0].operations));
        std::copy(c.starting_exprs.begin(), c.starting_exprs.end(), back_inserter(c.stensors[0].operations));
        vector<size_t> fs_idxs{};
        vector<Func> producers{};
        size_t idx = 0;
        for (const auto &s : c.stensors) {
            Place place = s.position == SMemType::HOST ? Place::Host : Place::Device;
            Func isolated_func(s.name, place);
            producers.push_back(std::move(isolated_func));
            if (!s.operations.empty())
                fs_idxs.push_back(idx);
            idx++;
        }
        vector<Func> _producers(producers.begin() + fs_idxs.back(), producers.end());
        debug(1) << "T2X emits: " << c.control_ure.name() << ".isolate_producer_chain({"
                 << names_to_string(c.stensors[fs_idxs.back()].operations) << "}, " << names_to_string(_producers) << ");\n";
        c.control_ure.isolate_producer_chain(c.stensors[fs_idxs.back()].operations, _producers);
        for (int i = fs_idxs.size() - 2; i >= 0; i--) {
            _producers.clear();
            _producers.insert(_producers.end(), producers.begin() + fs_idxs[i], producers.begin() + fs_idxs[i + 1]);
            debug(1) << "T2X emits: " << producers[fs_idxs[i + 1]].name() << ".isolate_producer_chain({"
                     << names_to_string(c.stensors[fs_idxs[i]].operations) << "}, " << names_to_string(_producers) << ");\n";
            producers[fs_idxs[i + 1]].isolate_producer_chain(c.stensors[fs_idxs[i]].operations, _producers);
        }
        return producers;
    }

#if 0
    void generate_output_array(Func out, Func drainer) {
        // TODO: check non-output-stationary dataflow
        auto src_vars = fv.ure.function().definition().schedule().transform_params()[0].src_vars;
        vector<string> pe_array_dims(src_vars.begin(), src_vars.end()-1);
        auto func_dims = out.function().args();

        for (auto u : pe_array_dims) {
            for (auto o : func_dims) {
                if (o == u)
                    output_array_dims.push_back(Var(o));
            }
        }
        debug(1) << "T2X emits: " << drainer.name() << ".space_time_transform("
                 << names_to_string(output_array_dims) << ");\n";
        drainer.space_time_transform(output_array_dims);
    }
#endif

    vector<Func> isolate_consumer(Schain &c) {
        vector<Func> consumers;
        if (c.stensors.back().position != HOST && c.write_to_host) {
            // If the host stensor is not specified, we automatically generate it
            string host_name = c.outf.name() + "_deserializer";
            Stensor s_host(host_name);
            s_host.schain_idx = c.stensors[0].schain_idx;
            c.stensors.push_back(s_host);
        }

        // Isolate subsequent consumers
        for (auto &s : c.stensors) {
            Place place = s.position == SMemType::HOST ? Place::Host : Place::Device;
            Func new_func(s.name, place);
            consumers.push_back(std::move(new_func));
        }
        if (c.stensors[0].v_banks.size() == 1) {
            // This is a special case where the single dimension banks are inside systolic array
            user_assert(!c.write_to_host ||  c.stensors[1].position == SMemType::DRAM);
            Var bank = c.stensors[0].v_banks[0];
            c.outf.value().accept(&fpo);
            debug(1) << "T2X emits: " << c.outf.name() << ".relay("
                     << fpo.producer.name() << ", " << bank.name() << ");\n";
            c.outf.relay(fpo.producer, bank);
            // The channel is inside the systolic array
            if (c.stensors[0].fifo_depth != 0) {
                c.outf.min_depth(c.stensors[0].fifo_depth);
            }
            // Remove the first stensor as it is inside systolic array
            c.stensors.erase(c.stensors.begin());
            consumers.erase(consumers.begin());
            if (!consumers.empty()) {
                // Vectorize all the subsequent stensors
                debug(1) << "T2X emits: " << c.outf.name() << ".isolate_consumer_chain("
                         << names_to_string(consumers) << ");\n";
                c.outf.isolate_consumer_chain(consumers);
                for (auto &f : consumers) {
                    debug(1) << "T2X emits: " << f.name() << ".vectorize("
                             << bank.name() << ");\n";
                    f.vectorize(bank);
                }
            }
        } else if (c.stensors[0].v_banks.size() == 2) {
            // The output stensor inherits loops of the output URE, generally less than that of systolic array
            // So we isolate the first consumer alone and apply space-time transform to regenerate loop structure,
            // then the subsequent stensors could be isolated based on that
            Func first_func = consumers[0];
            debug(1) << "T2X emits: " << c.outf.name() << ".isolate_consumer("
                     << first_func.name() << ");\n";
            c.outf.isolate_consumer(first_func);
            // generate_output_array(outf, f_dev);
            debug(1) << "T2X emits: " << first_func.name() << ".space_time_transform("
                     << names_to_string(c.stensors[0].v_banks) << ");\n";
            first_func.space_time_transform(c.stensors[0].v_banks);
            vector<Func> other_cons(consumers.begin()+1, consumers.end());
            debug(1) << "T2X emits: " << first_func.name() << ".isolate_consumer_chain("
                     << names_to_string(other_cons) << ");\n";
            first_func.isolate_consumer_chain(other_cons);
        } else {
            debug(1) << "T2X emits: " << c.outf.name() << ".isolate_consumer_chain("
                     << names_to_string(consumers) << ");\n";
            c.outf.isolate_consumer_chain(consumers);
        }
        return consumers;
    }

    // Remove reuse variables from stensors as per their scope
    void remove(Schain &c, vector<Func> &producers) {
        vector<VarOrRVar> loops;
        Var scope = c.stensors.back().v_scope;

        // Merge all the image params' (and starting expressions') used variables
        set<string> all_used_vars;
        for (auto image_param : c.imp) {
            const set<string> & used_variables = c.used_vars[image_param.name()];
            all_used_vars.insert(used_variables.begin(), used_variables.end());
        }
        for (size_t i = 0; i < c.starting_exprs.size(); i++) {
            const set<string> & used_variables = c.expr_used_vars[i];
            all_used_vars.insert(used_variables.begin(), used_variables.end());
        }

        for (int i = producers.size()-2; i >= 0; i--) {
            loops = c.find_reuse_vars(all_used_vars, scope);
            if (!loops.empty()) {
                debug(1) << "T2X emits: " << producers[i].name() << ".remove("
                         << names_to_string(loops) << ");\n";
                producers[i].remove(loops);
            }
            scope = (i > 0) ? c.stensors[i].v_scope : scope;
        }
    }

    Var find_differences(vector<Var> set_a, vector<Var> set_b) {
        for (const auto &a : set_a) {
            bool found = false;
            for (const auto &b : set_b)
                if (a.name() == b.name()) found = true;
            if (!found) return a;
        }
        return Var("");
    }

    // The scatter primitive only applies to the stensors with increasing dimensional banks (0->1, 1->2)
    void scatter(Schain &c, vector<Func> &producers) {
        internal_assert(c.stensors.size() == producers.size());
        vector<Var> &prev_dims = c.stensors[0].v_banks;

        for (size_t i = 1; i < c.stensors.size(); i++) {
            auto v_banks = c.stensors[i].v_banks;
            if (v_banks.size() == prev_dims.size()+1) {
                // Scatter happens only between two device kernels
                if (producers[i-1].function().place() == Place::Device && producers[i].function().place() == Place::Device) {
                    Func prev = producers[i-1];
                    Var v_scatter = find_differences(v_banks, prev_dims);
                    debug(1) << "T2X emits: " << producers[i].name() << ".scatter("
                            << prev.name() << ", " << v_scatter << ");\n";
                    producers[i].scatter(prev, v_scatter);
                }
            }
            prev_dims = v_banks;
        }
    }

    // The gather primitive only applies to the stensors with decreasing dimensional banks (2->1, 1->0)
    void gather(Schain &c, vector<Func> &consumers) {
        internal_assert(c.stensors.size() == consumers.size());
        auto &prev_dims = c.stensors[0].v_banks;

        for (size_t i = 1; i < c.stensors.size(); i++) {
            auto v_banks = c.stensors[i].v_banks;
            if (v_banks.size() == prev_dims.size()-1) {
                Func prev_1 = consumers[i-1];
                Func prev_2 = (i == 1) ? c.outf : consumers[i-2];
                Var v_gather = find_differences(prev_dims, v_banks);
                debug(1) << "T2X emits: " << prev_1.name() << ".gather("
                         << prev_2.name() << ", " << v_gather << ");\n";
                prev_1.gather(prev_2, v_gather);
                // Trick: The behavior of gather depends on bank dimensions
                // 2->1: Values transferred one by one via shift registers
                // 1->0: Values are gathered across banks and sent as a vector,
                //       to simplify vectorize phase, we perform it here
                if (v_banks.size() == 0) {
                    // producer
                    debug(1) << "T2X emits: " << prev_1.name() << ".vectorize("
                             << v_gather << ");\n";
                    prev_1.vectorize(v_gather);
                    // consumer
                    debug(1) << "T2X emits: " << consumers[i].name() << ".vectorize("
                             << v_gather << ");\n";
                    consumers[i].vectorize(v_gather);
                }
            }
            prev_dims = v_banks;
        }
    }

    void buffer(Schain &c, vector<Func> &producers) {
        internal_assert(c.stensors.size() == producers.size());
        for (size_t i = 0; i < c.stensors.size(); i++) {
            Var v_scope = c.stensors[i].v_scope;
            if (c.exists(v_scope) && c.stensors[i].position == SRAM) {
                Func prev = producers[i-1];
                debug(1) << "T2X emits: " << producers[i].name() << ".buffer("
                         << prev.name() << ", " << v_scope << ");\n";
                producers[i].buffer(prev, v_scope);
            }
        }
    }

    void vectorize(Schain &c, vector<Func> &funcs) {
        internal_assert(c.stensors.size() == funcs.size());
        // In general, each stensor could independently specify bankwidth,
        // so we do not check the consistency between the producer and consumer,
        // NOTE: Currently the producer and consumer must be consistent with manual work,
        // and we leave the sophisticated vectorization to future work
        for (size_t i = 0; i < c.stensors.size(); i++) {
            if (c.stensors[i].v_width.size() == 0)
                continue;
            user_assert(c.stensors[i].v_width.size() == 1)
                << "Currently we only support packing one dimension as a vector\n";
            Var v_width = c.stensors[i].v_width[0];
            if (c.exists(v_width)) {
                const auto &dims = funcs[i].function().definition().schedule().dims();
                const auto iter = std::find_if(dims.begin(), dims.end(), [](const Dim &d){
                    return d.for_type == ForType::Vectorized;
                });
                if (iter != dims.end() && iter->var != v_width.name() && !ends_with(iter->var, "." + v_width.name())) {
                    user_warning << "Func " << funcs[i].name() << " can't vectorize across "
                                 << v_width <<", because Func is already vectorized across " << iter->var << "\n";
                } else {
                    debug(1) << "T2X emits: " << funcs[i].name() << ".vectorize("
                            << v_width << ");\n";
                    funcs[i].vectorize(v_width);
                }
            }
        }

        // To make UREs be consistent with its producer, we vectorize UREs as well
        auto &last_stensor = c.stensors.back();
        if (!c.is_output && last_stensor.v_width.size() > 0) {
            Var last_width = last_stensor.v_width[0];
            const auto &dims = c.control_ure.function().definition().schedule().dims();
            const auto iter = std::find_if(dims.begin(), dims.end(), [](const Dim &d){
                return d.for_type == ForType::Vectorized;
            });
            if (iter != dims.end() && iter->var != last_width.name() && !ends_with(iter->var, "." + last_width.name())) {
                user_warning << "Func " << c.control_ure.name() << " can't vectorize across "
                             << last_width <<", because Func is already vectorized across " << iter->var << "\n";
            } else {
                debug(1) << "T2X emits: " << c.control_ure.name() << ".vectorize("
                        << last_width << ");\n";
                c.control_ure.vectorize(last_width);
            }
        }
    }

    void min_depth(Schain &c, vector<Func> &funcs) {
        internal_assert(c.stensors.size() == funcs.size());
        for (size_t i = 0; i < c.stensors.size(); i++) {
            size_t d = c.stensors[i].fifo_depth;
            if (d > 0) {
                debug(1) << "T2X emits: " << funcs[i].name() << ".min_depth("
                         << d << ");\n";
                funcs[i].min_depth(d);
            }
        }
    }

    // Check if the stensors are inclusive cache
    // Namely, for input chain the scope of consumer must be withini the scope of its producer,
    // TOFIX: for output chain the scope of consumer cannot below its predecessor?
    // If not specified, the scope is inherited
    void check_inclusiveness(Schain &c) {
        if (!c.is_output) {
            // start from the outermost loop
            int i = c.free_vars.size()-1;
            for (auto &s: c.stensors) {
                if (!c.exists(s.v_scope)) {
                    s.v_scope = c.free_vars[i];
                    continue;
                }
                int j = c.var_index(s.v_scope);
                user_assert(j > 0 && j <= i)
                    << "Error: The scope of " << s.name << " is outside of the scope of its predecessor\n";
                // Find a loop whose extent is not 1, otherwise this loop would be removed in lowering
                s.v_scope = c.find_non_unit_var(s.v_scope);
                i = j;
            }
        }
    }

    void find_banks(Schain &c) {
        // No space-time transformation, no need to allocate banks
        if (c.control_ure.function().definition().schedule().transform_params().empty())
            return;
        // The dst_vars includes space loops plus one time loop
        const auto &dst_vars = c.control_ure.function().definition().schedule().transform_params()[0].dst_vars;
        for (auto &s : c.stensors) {
            for (const auto &v : s.v_outs) {
                auto p = std::find_if(dst_vars.begin(), dst_vars.end()-1,
                                    [&](const string &n){ return v.name() == n; });
                if (p != dst_vars.end()-1) {
                    // Find it is in space loops, so we view it as a bank
                    s.v_banks.push_back(Var(*p));
                } else {
                    // Otherwise view it as bankwidth
                    s.v_width.push_back(Var(*p));
                }
            }
        }
    }

public:
    RealizeOnFPGA(FindVars &_v, FindProducerForOutput &_p)
        : fv(_v), fpo(_p) {}

    Func realize() {
        Func out;
        for (auto &c: schains) {
            check_inclusiveness(c);
            find_banks(c);
            if (!c.is_output) {
                vector<Func> producers;
                producers = isolate_producer(c);
                remove(c, producers);
                scatter(c, producers);
                buffer(c, producers);
                vectorize(c, producers);
                min_depth(c, producers);
            } else {
                vector<Func> consumers;
                consumers = isolate_consumer(c);
                gather(c, consumers);
                vectorize(c, consumers);
                min_depth(c, consumers);
                if (c.write_to_host)
                    out = consumers.back();
            }
        }
        internal_assert(out.defined());
        return out;
    }
};

class RealizeOnGPU
{
    FindVars &fv;
    int num_gpu_vars;

    // Check if the stensors are inclusive cache
    // Namely, for input chain the scope of consumer cannot be beyond its predecessor,
    // for output chain the scope of consumer cannot below its predecessor
    // If not specified, the scope is inherited
    void check_inclusiveness(Schain &c) {
        if (!c.is_output) {
            // start from the outermost loop
            int i = c.free_vars.size()-1;
            for (auto &s: c.stensors) {
                if (!c.exists(s.v_scope)) {
                    s.v_scope = c.free_vars[i];
                    continue;
                }
                int j = c.var_index(s.v_scope);
                user_assert(j > 0 && j <= i)
                    << "The scope of " << s.name << " is beyond its predecessor\n";
                // Find a loop whose extent is not 1, otherwise this loop would be removed in lowering
                s.v_scope = c.find_non_unit_var(s.v_scope);
                i = j;
            }
        }
    }

    void gpu_fetch(Schain &c) {
        for (auto &s : c.stensors) {
            // Currently, we separately allocate registers in each thread, and view registers
            // throughout threads as an unified SRAM storage, to realize stensors on GPUs.
            if (s.position == SRAM) {
                for (auto &p : c.imp) {
                    int gpu_var_index = c.free_vars.size() - num_gpu_vars -1;
                    Var loop = c.var_index(s.v_scope) < gpu_var_index ? s.v_scope : c.free_vars[gpu_var_index];
                    debug(1) << "T2X emits: " << p.name() << ".gpu_fetch("
                             << loop.name() << ", {" << names_to_string(s.v_outs) << "});\n";
                    p.gpu_fetch(loop, MemoryType::Register, s.v_outs);
                }
            }
        }
    }

    void gpu_store(Schain &c) {
        for (auto &s : c.stensors) {
            if (s.dims.size() > 0) {
                debug(1) << "T2X emits: " << c.outf.name() << ".gpu_store("
                         << to_string(s.dims) << ", " << s.name << ");\n";
                c.outf.gpu_store(s.dims, s.name);
            }
        }
    }

public:
    RealizeOnGPU(FindVars &_f, int _n)
        : fv(_f), num_gpu_vars(_n) {}

    Func realize() {
        Func out;
        for (auto &c : schains) {
            check_inclusiveness(c);
            if (!c.is_output) {
                gpu_fetch(c);
            } else {
                gpu_store(c);
                out = c.outf;
            }
        }
        return out;
    }
};

Func &operator>>(Func &func, const FIFO &fifo) {
    debug(1) << "T2X emits: " << func.name() << ".min_depth("
             << fifo.depth << ");\n";
    func.min_depth(fifo.depth);
    return func;
}

Stensor &operator>>(Stensor &s, const FIFO &fifo) {
    s.fifo_depth = fifo.depth;
    return s;
}

Func Stensor::stensor_realize_wrapper(Starget t) {
    int c = this->schain_idx;
    user_assert(schains[c].is_output)
        << "Please realize the stensors on the output path\n";
    user_assert(this->position == SMemType::HOST)
        << "Stensors must be realized on the host\n";

    map<string, Func> env;
    Func outf = schains[c].outf;
    env = outf.pipeline().compute_environment();

    Func f;
    if (t == Starget::IntelFPGA) {
        FindVars fv(env);
        FindProducerForOutput fpo(env);
        RealizeOnFPGA fpga(fv, fpo);
        std::map<string, Function> new_env{};
        for (const auto &p : env)
            new_env.emplace(p.first, p.second.function());
        const auto call_graph = build_reverse_call_graph(build_call_graph(new_env));
        for (auto &c : schains)
            if (c.is_output) {
                const auto outf_name = c.outf.function().name();
                c.write_to_host = call_graph.at(outf_name).empty() ||
                    std::any_of(
                        call_graph.at(outf_name).begin(),
                        call_graph.at(outf_name).end(),
                        [&](const string &func_name) {
                            return new_env[func_name].place() == Place::Host;
                        });
            }
        f = fpga.realize();
        internal_assert(f.function().place() == Place::Host);
    }
    if (t == Starget::IntelGPU) {
        int num_gpu_vars = 0;
        for (auto &p : env) {
            if (p.second.function().place() == Place::Device) {
                // Placing on device is only valid for FPGAs
                p.second.function().place(Place::Host);
            }
            reorder_gpu_loops(p.second, num_gpu_vars);
        }
        FindVars fv(env);
        RealizeOnGPU gpu(fv, num_gpu_vars);
        f = gpu.realize();
    }

    for (auto condition : conditions_of_asserts) {
        f.require(condition);
    }

    return f;
}

void Stensor::realize(Buffer<> dst, Starget t) {
    Func f = stensor_realize_wrapper(t);
    if (t == Starget::IntelFPGA) {
        Target acc = get_host_target();
        acc.set_feature(Target::IntelFPGA);
        acc.set_feature(Target::EnableSynthesis);
        f.realize(dst, acc);
    }
    if (t == Starget::IntelGPU) {
        user_error << "Currently the GPU runtime is under developement\n";
    }
}

void Stensor::compile_jit(Starget t) {
    Func f = stensor_realize_wrapper(t);
    if (t == Starget::IntelFPGA) {
        Target acc = get_host_target();
        acc.set_feature(Target::IntelFPGA);
        acc.set_feature(Target::EnableSynthesis);
        f.compile_jit(acc);
    }
}

void Stensor::compile_to_host(string file_name, const vector<Argument> &args,
                              const std::string fn_name, Starget t) {
    Func f = stensor_realize_wrapper(t);
    if (t == Starget::IntelFPGA) {
        Target acc = get_host_target();
        acc.set_feature(Target::IntelFPGA);
        acc.set_feature(Target::EnableSynthesis);
        f.compile_to_host(file_name, args, fn_name, acc);
    }
    if (t == Starget::IntelGPU) {
        user_warning << "Currently the GPU runtime is under developement, "
                        "so we just emit out the source code in " << fn_name << "_genx.cpp\n";
        Target acc = get_host_target();
        acc.set_feature(Target::IntelGPU);
        f.compile_to_cm(fn_name, std::move(args), acc);
    }
}


void Stensor::compile_to_oneapi(const string &file_name,
                                const vector<Argument> &args,
                                const std::string &fn_name,
                                const vector<Expose> &exposed_parts,
                                Starget t,
                                const vector<Target::Feature> &features) {
    Func f = stensor_realize_wrapper(t);
    Target acc = get_host_target();
    acc.set_feature(Target::OneAPI);
    for (auto feature : features) {
        acc.set_feature(feature);
    }
    if (t == Starget::IntelFPGA) {
        acc.set_feature(Target::IntelFPGA);
        acc.set_feature(Target::EnableSynthesis);
        f.compile_to_oneapi(file_name, args, fn_name, exposed_parts, acc);
    }
}

}
