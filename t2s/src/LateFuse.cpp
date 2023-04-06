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
#include "IR.h"
#include "IRMutator.h"
#include "IROperator.h"
#include "DebugPrint.h"
#include "LateFuse.h"
#include "Utilities.h"
#include "BuildCallRelation.h"

#include "../../Halide/src/Substitute.h"
#include "../../Halide/src/Simplify.h"

namespace Halide {
namespace Internal {

// Get the channel to be replaced by the registers
class GetReplacedChannel : public IRVisitor {
    using IRVisitor::visit;
    set<string> producers;
    string consumer;
    set<string> read_channels;
    set<string> write_channels;
    bool is_in_producer;
    bool is_in_merged_func;
public:
    GetReplacedChannel(const string &producer, const string &consumer, const std::map<std::string, Function> &env)
        : consumer{consumer}, is_in_producer{false}, is_in_merged_func{false} {
            producers.insert(producer);
            if (env.at(producer).has_merged_defs())
                for (const auto &name : env.at(producer).merged_func_names())
                    producers.insert(name);
        }
    void visit(const ProducerConsumer *op) override {
        if (producers.find(op->name) != producers.end() && not op->is_producer) {
            is_in_producer = true;
        } else if (op->name == consumer && op->is_producer && is_in_producer) {
            is_in_merged_func = true;
        } else if (op->name == consumer && not op->is_producer) {
            is_in_merged_func = false;
        }
        op->body.accept(this);
    }
    void visit(const Call *op) override {
        if (is_in_merged_func) {
            if (op->is_intrinsic(Call::read_channel)) { 
                internal_assert(op->args[0].as<StringImm>());
                read_channels.insert(op->args[0].as<StringImm>()->value);
            } else if (op->is_intrinsic(Call::write_channel)) {
                internal_assert(op->args[0].as<StringImm>());
                write_channels.insert(op->args[0].as<StringImm>()->value);
            }
            IRVisitor::visit(op);
        }
    }
    string get_replaced_channel() const {
        if (producers.size() == 1) {
            return *producers.begin();
        } else {
            vector<string> res{};
            std::set_intersection(
                    write_channels.begin(), write_channels.end(), 
                    read_channels.begin(), read_channels.end(),
                    std::back_inserter(res));
            internal_assert(res.size() == 1) << "There is one and only one channel that can be replaced";
            return remove_postfix(res[0], ".channel");
        }
    }
};

class ReplaceChannelsWithRegs: public IRMutator {
    using IRMutator::visit;

    string fuse_func_name;
    Region bounds;
    const std::vector<string> &access_args;
    std::vector<string> loop_names;
    Stmt buffer_stmt;

public:
    ReplaceChannelsWithRegs(string fuse_func_name, Region bounds, const std::vector<string> &access_args, Stmt buffer_stmt) 
                            : fuse_func_name(fuse_func_name), bounds(bounds), access_args(access_args), buffer_stmt(buffer_stmt) {}

    Expr visit(const Call *op) override {
        if (op->is_intrinsic(Call::read_channel)) {
            internal_assert(op->args[0].as<StringImm>());
            string name = op->args[0].as<StringImm>()->value;
            if (name == fuse_func_name + ".channel") {
                std::vector<Expr> cons_read_args;  // args for consumer to read registers
                for (auto arg : access_args) {
                    bool found = false;
                    for (auto name : loop_names) {
                        if (extract_last_token(name) == arg) {
                            found = true;
                            cons_read_args.push_back(Variable::make(Int(32), name));
                            break;
                        }
                    }
                    if (!found) {
                        cons_read_args.push_back(Call::make(Int(32), arg + ".temp", {}, Call::Intrinsic));
                    }
                }
                debug(4) << "cons_read_args: " << to_string<Expr>(cons_read_args) << "\n";
                std::vector<Expr> new_args(cons_read_args);
                new_args.insert(new_args.begin(), StringImm::make(fuse_func_name + ".shreg"));
                return Call::make(op->type, Call::read_shift_reg, new_args, op->call_type, op->func, op->value_index,
                                  op->image, op->param);
            } else {
                return IRMutator::visit(op);
            }
        }
        if (op->is_intrinsic(Call::write_channel)) {
            internal_assert(op->args[0].as<StringImm>());
            string name = op->args[0].as<StringImm>()->value;
            if (name == fuse_func_name + ".channel") {
                std::vector<Expr> prod_write_args; // args for producer to write registers
                for (auto arg : access_args) {
                    bool found = false;
                    for (auto name : loop_names) {
                        if (extract_last_token(name) == arg) {
                            found = true;
                            prod_write_args.push_back(Variable::make(Int(32), name));
                            break;
                        }
                    }
                    if (!found) {
                        prod_write_args.push_back(Call::make(Int(32), arg + ".temp", {}, Call::Intrinsic));
                    }
                }
                debug(4) << "prod_write_args: " << to_string<Expr>(prod_write_args) << "\n";
                std::vector<Expr> new_args(prod_write_args);
                new_args.insert(new_args.begin(), StringImm::make(fuse_func_name + ".shreg"));
                new_args.push_back(op->args[1]);
                return Call::make(op->type, Call::write_shift_reg, new_args, op->call_type, op->func, op->value_index,
                                  op->image, op->param);
            } else {
                return IRMutator::visit(op);
            }
        }
        return IRMutator::visit(op);
    }

    Stmt visit(const For *op) override {
        if (!ends_with(op->name, ".run_on_device")) {
            loop_names.push_back(op->name);
        }
        Stmt s = IRMutator::visit(op);
        if (!ends_with(op->name, ".run_on_device")) {
            loop_names.pop_back();
        }
        return s;
    }

    Stmt visit(const Realize *op) override {
        if (op->name == fuse_func_name + ".channel") {
            Stmt body = mutate(op->body);
            const LetStmt *let = buffer_stmt.as<LetStmt>();
            body = Realize::make(fuse_func_name + ".shreg", op->types,
                                 op->memory_type, bounds,
                                 op->condition, body);
            if (let != nullptr) {
                body = LetStmt::make(let->name, let->value, body);
            }
            return body;
        }
        return IRMutator::visit(op);
    }
};

class CollectLoopInfo: public IRMutator {
    using IRMutator::visit;

    std::string fuse_level;
    bool under_fuse_level;
    std::map<std::string, Range> &loop_info;

public:
    CollectLoopInfo(std::string fuse_level, std::map<std::string, Range> &loop_info) : fuse_level(fuse_level), loop_info(loop_info) {
        under_fuse_level = false;
    }

    Stmt visit(const For *op) override {
        if (op->name == fuse_level) {
            under_fuse_level = true;
            Stmt s = (ends_with(op->name, ".run_on_device")) ? IRMutator::visit(op) : mutate(op->body);
            under_fuse_level = false;
            return s;
        } else if (under_fuse_level) {
            std::string loop_var = extract_last_token(op->name);
            if (loop_var != "scatter" && loop_var != "gather" && loop_var != "run_on_device") {
                loop_info.insert({loop_var, Range(op->min, op->extent)});
            }
            return IRMutator::visit(op);
        } else {
            return (ends_with(op->name, ".run_on_device")) ? IRMutator::visit(op) : mutate(op->body);
        }
    }
};

class PreprocessBeforeFusing: public IRMutator {
    using IRMutator::visit;

    Function fuse_func;
    std::string fuse_level;
    std::map<std::string, Range> &loop_info;

public:
    Stmt fused_body;
    Stmt buffer_stmt;

    PreprocessBeforeFusing(Function f, std::string v, std::map<std::string, Range> &loop_info) 
                           : fuse_func(f), fuse_level(v), loop_info(loop_info) {
    }

    Stmt visit(const ProducerConsumer *op) override {
        if (op->name == fuse_func.name()) {
            if (op->is_producer) {
                mutate(op->body);
                return make_empty_stmt();
            } else {
                return mutate(op->body);
            }
        }
        return IRMutator::visit(op);
    }

    Stmt visit(const For *op) override {
        if (op->name == fuse_func.name() + ".s0.run_on_device") {
            std::string loop_name = fuse_func.name() + ".s0" + "." + extract_last_token(fuse_level);
            CollectLoopInfo collector(loop_name, loop_info);
            fused_body = For::make(op->name, op->min, op->extent, op->for_type, op->device_api, op->body);
            fused_body = collector.mutate(fused_body);
            fused_body = substitute(loop_name, Variable::make(Int(32), fuse_level), fused_body);
        }
        return IRMutator::visit(op);
    }

    Stmt visit(const LetStmt *op) override {
        if (op->name == fuse_func.name() + ".buffer") {
            buffer_stmt = LetStmt::make(op->name, op->value, op->body);
            return mutate(op->body);
        }
        return IRMutator::visit(op);
    }
}; 


// Get the shift registers' name
class GetRegName : public IRVisitor {
    using IRVisitor::visit;
    string channel_name;
public:
    string reg_name;

    GetRegName(const string& name) : channel_name{name}, reg_name{} {}

    void visit(const Call *op) override {
        if (op->is_intrinsic(Call::write_channel)) {
            internal_assert(op->args[0].as<StringImm>());
            string name = op->args[0].as<StringImm>()->value;
            if (name == channel_name + ".channel") {
                const auto *func_call = op->args[1].as<Call>();
                if (func_call != nullptr && func_call->is_intrinsic(Call::read_shift_reg)) {
                    internal_assert(func_call->args[0].as<StringImm>());
                    reg_name = func_call->args[0].as<StringImm>()->value;
                } 
            }
        }
        IRVisitor::visit(op);
    }
};

class ReplaceChannelsWithFlattenedRegs : public IRMutator {
    using IRMutator::visit;
    string reg_name;
    string channel_name;
    string consumer_name;
    bool contain_write_or_read_regs;

    struct kernel_info {
        string name;
        Expr min;
        Expr extent;
        ForType for_type;
        DeviceAPI device_api;
    };

    vector<kernel_info> kernel_infos;

    struct GetAllMergedKernels : public IRVisitor {
        using IRVisitor::visit;
        vector<kernel_info> &kernel_infos;
        GetAllMergedKernels(vector<kernel_info> &kernel_infos)
            : kernel_infos{kernel_infos} {}
        void visit(const For *op) override {
            if (ends_with(op->name, ".run_on_device")) {
                kernel_info k = {op->name, op->min, op->extent, op->for_type, op->device_api};
                kernel_infos.emplace_back(std::move(k));
            }
            op->body.accept(this);
        }
    };

public:
    ReplaceChannelsWithFlattenedRegs(const string &reg_name, const string &channel_name, const string &consumer_name)
        : reg_name{reg_name}, channel_name{channel_name},
          consumer_name{consumer_name}, contain_write_or_read_regs{false}, 
          kernel_infos{} {}

    Stmt visit(const Realize *op) override {
        if (op->name == reg_name) {
            auto body = mutate(op->body);
            body = Realize::make(channel_name + "_temp.shreg", op->types,
                    op->memory_type, op->bounds, op->condition, body);
            body = Realize::make(reg_name, op->types,
                    op->memory_type, op->bounds, op->condition, body);
            return Realize::make("addr.temp", {Int(32)}, MemoryType::Auto, {}, op->condition, std::move(body));
        } 
        return IRMutator::visit(op);
    }

    Expr visit(const Call *op) override {
        if (op->is_intrinsic(Call::write_channel)) {
            internal_assert(op->args[0].as<StringImm>());
            string name = op->args[0].as<StringImm>()->value;
            if (name == channel_name + ".channel") {
                contain_write_or_read_regs = true;
                return Call::make(
                        op->type, Call::write_shift_reg,
                        {StringImm::make(channel_name + "_temp.shreg"), Call::make(Int(32), "addr.temp", {}, Call::CallType::Halide), op->args[1]},
                        op->call_type, op->func, op->value_index, op->image, op->param);
            }
            return IRMutator::visit(op);
        }
        if (op->is_intrinsic(Call::read_channel)) {
            internal_assert(op->args[0].as<StringImm>());
            string name = op->args[0].as<StringImm>()->value;
            if (name == channel_name + ".channel") {
                contain_write_or_read_regs = true;
                return Call::make(
                        op->type, Call::read_shift_reg,
                        {StringImm::make(channel_name + "_temp.shreg"), Call::make(Int(32), "addr.temp", {}, Call::CallType::Halide)},
                        op->call_type, op->func, op->value_index, op->image, op->param);
            }
            return IRMutator::visit(op);
        }
        return IRMutator::visit(op);
    }

    Stmt visit(const ProducerConsumer *op) override {
        if (op->is_producer && op->name == channel_name) {
            GetAllMergedKernels finder{kernel_infos};
            finder.visit(op);
            mutate(op->body);
            return make_empty_stmt(); 
        } else {
            return IRMutator::visit(op);
        }
    }

    Stmt visit(const For *op) override {
        if (starts_with(op->name, consumer_name) and ends_with(op->name, ".run_on_device")) {
            auto body = mutate(op->body);
            for (auto iter = kernel_infos.rbegin(); iter != kernel_infos.rend(); iter++) {
                body = For::make(iter->name, iter->min,
                        iter->extent, iter->for_type, iter->device_api, std::move(body));
            }
            return For::make(op->name, op->min, op->extent, op->for_type, op->device_api, std::move(body));
        }
        const bool before_val = contain_write_or_read_regs;
        auto res = IRMutator::visit(op);
        if (not before_val && contain_write_or_read_regs) {
            auto *for_node = res.as<For>();
            contain_write_or_read_regs = false;
            return For::make(for_node->name, for_node->min, for_node->extent,
                    for_node->for_type, for_node->device_api,
                    Block::make(for_node->body, 
                        Provide::make("addr.temp", {Add::make(Call::make(Int(32), "addr.temp", {}, Call::CallType::Halide), IntImm::make(Int(32), 1))}, {})));
        }
        return res;
    }

    Stmt visit(const IfThenElse *op) override {
        const bool before_val = contain_write_or_read_regs;
        Expr condition = mutate(op->condition);
        Stmt then_case = mutate(op->then_case);
        if (not before_val && contain_write_or_read_regs) {
            then_case = Block::make(then_case,
                    Provide::make("addr.temp", {Add::make(Call::make(Int(32), "addr.temp", {}, Call::CallType::Halide), IntImm::make(Int(32), 1))}, {}));
            contain_write_or_read_regs = false;
        }
        Stmt else_case = mutate(op->else_case);
        if (not before_val &&  contain_write_or_read_regs) {
            else_case = Block::make(else_case,
                    Provide::make("addr.temp", {Add::make(Call::make(Int(32), "addr.temp", {}, Call::CallType::Halide), IntImm::make(Int(32), 1))}, {}));
            contain_write_or_read_regs = false;
        }
        return IfThenElse::make(std::move(condition), std::move(then_case), std::move(else_case));
    }
};

class LateFuse: public IRMutator {
    using IRMutator::visit;

    bool fuse_flag;
    std::string fuse_level;
    Stmt fused_body;

public:
    LateFuse(bool fuse_flag, std::string v, Stmt fused_body) 
             : fuse_flag(fuse_flag), fuse_level(v), fused_body(fused_body) {
    }

    Stmt visit(const For *op) override {
        if (starts_with(op->name, fuse_level)) {
            Stmt body_s = Block::make(Provide::make("addr.temp", {IntImm::make(Int(32), 0)}, {}), mutate(op->body));
            fused_body = Block::make(Provide::make("addr.temp", {IntImm::make(Int(32), 0)}, {}), fused_body);
            Stmt block_s;
            if (fuse_flag) {
                block_s = Block::make(body_s, fused_body);
            } else {
                block_s = Block::make(fused_body, body_s);
            }
            Stmt for_s = For::make(op->name, op->min, op->extent,
                                   op->for_type, op->device_api, block_s);
            return for_s;
        }
        return IRMutator::visit(op); 
    }
}; 

class DataAccessTransform: public IRMutator {
    using IRMutator::visit;

    Function fuse_func;
    int v_outs;
    string v_loop_name;
    string scatter_or_gather_loop_name;
    bool in_fused_kernel = false;
    Expr ori_reg_call;
    Expr new_reg_call;

public:
    DataAccessTransform(Function f, int v_outs) 
                        : fuse_func(f), v_outs(v_outs) {}

    Stmt visit(const For *op) override {
        if (starts_with(op->name, fuse_func.name()) && (ends_with(op->name, "scatter") || ends_with(op->name, "gather"))) {
            scatter_or_gather_loop_name = op->name;
            Stmt body = mutate(op->body);
            const Block *blk = body.as<Block>();
            internal_assert(blk != nullptr);
            Stmt new_body;
            if (blk->first.as<Provide>() != nullptr && blk->rest.as<For>() != nullptr) {
                Stmt first_part = For::make(v_loop_name, Expr(0), Expr(v_outs), ForType::PragmaUnrolled, op->device_api, blk->first);
                const For *for_op = blk->rest.as<For>();
                Stmt rest_part = For::make(v_loop_name, Expr(0), Expr(v_outs), ForType::PragmaUnrolled, op->device_api, for_op->body);
                rest_part = For::make(for_op->name, for_op->min, simplify(for_op->extent/v_outs), for_op->for_type, for_op->device_api, rest_part);
                new_body = Block::make(first_part, rest_part);
            } else if (blk->first.as<For>() != nullptr && blk->rest.as<Store>() != nullptr) {
                const For *for_op = blk->first.as<For>();
                Stmt first_part = For::make(v_loop_name, Expr(0), Expr(v_outs), ForType::PragmaUnrolled, op->device_api, for_op->body);
                first_part = For::make(for_op->name, for_op->min, simplify(for_op->extent/v_outs), for_op->for_type, for_op->device_api, first_part);
                Stmt rest_part = For::make(v_loop_name, Expr(0), Expr(v_outs), ForType::PragmaUnrolled, op->device_api, blk->rest);
                new_body = Block::make(first_part, rest_part);
            } else {
                internal_assert(false);
            }
            return For::make(op->name, op->min, simplify(op->extent/v_outs), op->for_type, op->device_api, new_body);
        }
        if (starts_with(op->name, fuse_func.name()) && ends_with(op->name, "run_on_device")) {
            in_fused_kernel = true;
            Stmt s = IRMutator::visit(op);
            in_fused_kernel = false;
            return s;
        }
        return IRMutator::visit(op); 
    }

    Stmt visit(const Realize *op) override {
        if (in_fused_kernel && (ends_with(op->name, "scatter.temp") || ends_with(op->name, "gather.temp"))) {
            Region bounds;
            bounds.push_back(Range(0, v_outs));
            v_loop_name = unique_name("dummy") + ".s0.v";
            ori_reg_call = Call::make(op->types[0],op->name,{},Call::PureIntrinsic);
            new_reg_call = Call::make(op->types[0],op->name,{Variable::make(Int(32), v_loop_name)},Call::PureIntrinsic);
            return Realize::make(op->name, op->types, op->memory_type, bounds, op->condition, mutate(op->body));
        }
        return IRMutator::visit(op); 
    }

    Stmt visit(const Provide *op) override {
        if (in_fused_kernel && (ends_with(op->name, "scatter.temp") || ends_with(op->name, "gather.temp"))) {
            auto values = op->values;
            for (size_t i = 0; i < values.size(); ++i) {
                values[i] = mutate(values[i]);
                values[i] = substitute(ori_reg_call, new_reg_call, values[i]);
                auto l = Variable::make(Int(32), scatter_or_gather_loop_name);
                values[i] = substitute(l, l*v_outs+Variable::make(Int(32), v_loop_name), values[i]);
            }
            return Provide::make(op->name, values, {Variable::make(Int(32), v_loop_name)});
        }
        return IRMutator::visit(op); 
    }

    Stmt visit(const Store *op) override {
        if (in_fused_kernel && op->name == fuse_func.name()) {
            Stmt s = Store::make(op->name, op->value, op->index, op->param, op->predicate, op->alignment);
            s = substitute(ori_reg_call, new_reg_call, s);
            auto l = Variable::make(Int(32), scatter_or_gather_loop_name);
            s = substitute(l, l*v_outs+Variable::make(Int(32), v_loop_name), s);
            return s;
        }
        return IRMutator::visit(op); 
    }

    Expr visit(const Call *op) override {
        if (in_fused_kernel && op->is_intrinsic(Call::read_shift_reg)) {
            Expr e = Call::make(op->type, Call::read_shift_reg, op->args, op->call_type, op->func, op->value_index,
                                op->image, op->param);
            e = substitute(ori_reg_call, new_reg_call, e);
            auto l = Variable::make(Int(32), remove_postfix(scatter_or_gather_loop_name, "." + extract_last_token(scatter_or_gather_loop_name)));
            e = substitute(l, l*v_outs+Variable::make(Int(32), v_loop_name), e);
            return e;
        } else if (in_fused_kernel && op->is_intrinsic(Call::write_shift_reg)) {
            Expr e = Call::make(op->type, Call::write_shift_reg, op->args, op->call_type, op->func, op->value_index,
                                op->image, op->param);
            e = substitute(ori_reg_call, new_reg_call, e);
            auto l = Variable::make(Int(32), remove_postfix(scatter_or_gather_loop_name, "." + extract_last_token(scatter_or_gather_loop_name)));
            e = substitute(l, l*v_outs+Variable::make(Int(32), v_loop_name), e);
            return e;
        }
        return IRMutator::visit(op); 
    }
}; 

Stmt do_late_fuse(Stmt stmt, const std::map<std::string, Function> &env) {
    const auto call_graph = build_call_graph(env, true, true);
    for (auto &pair : env) {
        const std::string late_fuse_level = pair.second.schedule().late_fuse_params().late_fuse_level;
        if (!late_fuse_level.empty()) {
            /* A.late_fuse(B, i) */
            /* original IR */
            /* 
            realize channel ch[] {
                producer A {                  // kernel A
                    for  i, j, k
                        write channel ch[]
                }
                consumer A {
                    producer B {              // kernel B
                        for i, j, k
                            read channel ch[]
                    }
                }
            }
            */
            std::map<std::string, Range> loop_info;
            Stmt fused_body;
            PreprocessBeforeFusing processor(pair.second, late_fuse_level, loop_info);
            stmt = processor.mutate(stmt);
            const auto original_name = extract_first_token(late_fuse_level);
            const auto producers = call_graph.at(original_name);
            bool fuse_flag = not (std::find(producers.begin(), producers.end(), pair.first) != producers.end()
                          || pair.second.isolated_from_as_producer() == original_name);
            
            if (!fuse_flag) {
                debug(3) << "Fuse producer " << pair.first << " with consumer " << extract_first_token(late_fuse_level) <<"\n";
            } else {
                debug(3) << "Fuse producer " << extract_first_token(late_fuse_level) << " with consumer " << pair.first <<"\n";
            }

            Region bounds;                   // bounds for realize of the registers
            std::vector<string> access_args; // args for accessing registers
            for (auto kv : loop_info) {
                bounds.push_back(kv.second);
                access_args.push_back(kv.first);
            }


            LateFuse fuse(fuse_flag, late_fuse_level, processor.fused_body);
            stmt = fuse.mutate(stmt);
            /*
            realize channel ch[] {
                producer B {
                    for i
                        for j, k
                            write channel ch[]
                        for j, k
                            read channel ch[]
                }
            }
            */

            string channel_name{};
            if (!fuse_flag) {
                GetReplacedChannel finder{pair.second.name(), original_name, env};
                stmt.accept(&finder);
                channel_name = finder.get_replaced_channel();
            } else {
                GetReplacedChannel finder{pair.second.isolated_from_as_consumer(), pair.first, env};
                stmt.accept(&finder);
                channel_name = finder.get_replaced_channel();
            }

            GetRegName finder{channel_name};
            stmt.accept(&finder);

            if (finder.reg_name.empty()) {
                ReplaceChannelsWithRegs replacer(channel_name, bounds, access_args, processor.buffer_stmt);
                stmt = replacer.mutate(stmt);
            } else {
                ReplaceChannelsWithFlattenedRegs replacer(finder.reg_name, channel_name, fuse_flag ? pair.first : original_name);
                stmt = replacer.mutate(stmt);
            }

            /*
            realize shreg r[][] {
                producer B {
                    for i
                        for j, k
                            write reg r[][]
                        for j, k
                            read reg r[][]
                }
            }
            */
            int v_outs = pair.second.schedule().late_fuse_params().v_outs;

            if (v_outs > 1) {
                DataAccessTransform trans(pair.second, v_outs);
                stmt = trans.mutate(stmt);
            }
        }
    }

    return stmt;
}

}  // namespace Internal
}  // namespace Halide
