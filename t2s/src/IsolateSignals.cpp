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
#include "./IsolateSignals.h"
#include "./DebugPrint.h"
#include "./Utilities.h"
#include "IREquality.h"
#include "IRMutator.h"
#include "IRVisitor.h"
#include "Substitute.h"
#include <algorithm>

namespace Halide {
namespace Internal {

// A condition that can be isolated can contain only variables of image params, or time loops.
// It should be simple conditions without complicated sub-expression.
class CheckConditionForIsolation : public IRVisitor {
    using IRVisitor::visit;
private:
    const vector<const For *> &time_loops;
    const map<string, Expr>   &name2value; // Variable name to value, collected from Let or LetStmt
public:
    bool isolatable;
    CheckConditionForIsolation(const vector<const For *> &time_loops, const map<string, Expr> &name2value) :
        time_loops(time_loops), name2value(name2value), isolatable(true) { }

    void visit(const Variable *op) override {
        if (op->param.defined()) { // The variable is referring to an ImageParam's min or extent.
            return;
        }

        const string &name = op->name;
        for (auto &t : time_loops) {
            if (t->name == name) {
                return;
            }
        }
        if (name2value.find(op->name) != name2value.end()) {
            Expr value = name2value.find(op->name)->second;
            value.accept(this);
            return;
        }

        isolatable = false;
    }

    void visit(const Load *op) override {
        isolatable = false;
    }

    void visit(const Ramp *op) override {
        isolatable = false;
    }

    void visit(const Broadcast *) override {
        isolatable = false;
    }
    void visit(const Call *) override {
        isolatable = false;
    }

    void visit(const Let *) override {
        isolatable = false;
    }
};

bool condition_can_be_isolated(const Expr &condition, const vector<const For *> &time_loops, const map<string, Expr> &name2value) {
    CheckConditionForIsolation checker(time_loops, name2value);
    condition.accept(&checker);
    return checker.isolatable;
}

class IsolateCondition : public IRMutator {
    using IRMutator::visit;
private:
    const vector<const For *> &time_loops;
    const map<string, Expr>   &name2value; // Variable name to value, collected from Let or LetStmt

public:
    vector<pair<Expr, string>>  &signals; // Each pair is for a signal: the original expression of the signal, the new name to replace the expression

    Expr create_signal(const Expr &e) {
        // Look up existing signals. If any matches, return the substitute to this expression.
        // Otherwise, create a new pair and record it, and return the substitute.
        for (auto pair : signals) {
            if (equal(e, pair.first)) {
                return Variable::make(e.type(), pair.second);
            }
        }
        string substitute = unique_name("signal" + std::to_string(signals.size()));
        signals.push_back(pair<Expr, string>(e, substitute));
        return Variable::make(e.type(), substitute);
    }

#define VISIT_LOGIC_OP(EXPR, OPERATION, OPERANDA, OPERANDB)  \
    bool OK_to_isolate_operand_a = condition_can_be_isolated(OPERANDA, time_loops, name2value); \
    bool OK_to_isolate_operand_b = condition_can_be_isolated(OPERANDB, time_loops, name2value); \
    if (OK_to_isolate_operand_a && OK_to_isolate_operand_b) { \
        return create_signal(EXPR);  \
    } else if (OK_to_isolate_operand_a) { \
        return OPERATION::make(create_signal(OPERANDA), IRMutator::mutate(OPERANDB)); \
    } else if (OK_to_isolate_operand_b) { \
        return OPERATION::make(IRMutator::mutate(OPERANDA), create_signal(OPERANDB)); \
    } else { \
        return IRMutator::visit(EXPR); \
    }

#define VISIT_CONDITION(EXPR) \
    if (condition_can_be_isolated(EXPR, time_loops, name2value)) { \
        return create_signal(EXPR); \
    } else { \
        return IRMutator::visit(EXPR); \
    }

public:
    IsolateCondition(const vector<const For *> &time_loops, const map<string, Expr> &name2value, vector<pair<Expr, string>> &signals) :
        time_loops(time_loops), name2value(name2value), signals(signals) { }

    Expr visit(const EQ *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const NE *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const LT *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const LE *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const GT *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const GE *op) override {
        VISIT_CONDITION(op);
    }

    Expr visit(const And *op) override {
        VISIT_LOGIC_OP(op, And, op->a, op->b);
    }

    Expr visit(const Or *op) override {
        VISIT_LOGIC_OP(op, Or, op->a, op->b);
    }

    Expr visit(const Not *op) override {
        bool OK_to_isolate_operand_a = condition_can_be_isolated(op->a, time_loops, name2value);
        if (OK_to_isolate_operand_a) { \
            return create_signal(op);
        } else {
            return IRMutator::visit(op);
        }
    }
#undef VISIT_LOGIC_OP
#undef VISIT_CONDITION
};

// Isolate signals out of run_forever kernels into separate kernels.
// To be valid, a run_forever kernel must respect the following constraints:
// 1. Unrolled and vectorized loops must be at the innermost levels. That is, time loops are outside them.
// 2. The time loops' variables can only be referenced outside the unrolled and vectorized loops.
// 3. The time loops' variables can only be referenced in boolean expressions.
class IsolateSignals : public IRMutator {
    using IRMutator::visit;
private:
    map<string, Function> &env;

    // Temporary states when visiting the IR
    bool in_run_forever_func;         // In a function marked as run_forever
    bool in_space_loops;              // In unrolled or vectorized loops
    string run_forever_func_name;     // The name of the run_forever function

    // Final results after visiting a function's IR
    DeviceAPI device_api;               // The device api for the run_forever function
    vector<const For *> time_loops;     // Time loops to isolate
    vector<pair<Expr, string>> signals; // Each pair is for a signal: original expression, the new name to replace it (whose value will be sent from a signal generator)
    map<string, Expr> name2value;       // Variable name to value, collected from Let or LetStmt
    Type struct_type_for_signals;       // A struct type whose fields are the types of each signal
    string signals_var_name;            // A variable representing all the signals
    string signal_generator_name;       // Name of the signal generator function

    bool run_forever(const string &func_name) {
        // Look up the function name in the environment
        for (auto &pair : env) {
            if (pair.first == func_name && pair.second.run_forever()) {
                return true;
            }
        }
        return false;
    }

    Expr try_isolate(const Expr &condition) {
        IsolateCondition isolator(time_loops, name2value, signals);
        Expr e = isolator.mutate(condition);
        return e;
    }

    // Create a struct type for the signals.
    Type create_type_for_signals() {
        vector<Type> signals_types;
        for (auto pair: signals) {
            signals_types.push_back(pair.first.type());
        }
        return generate_struct(signals_types);
    }

    Stmt create_reading_of_signals(const Stmt &body) {
        // We want the IR looks like: for example, assume two signals
        //      signals = read channel from the signal generator
        //      signal0 = signals.f0;
        //      signal1 = signals.f1;
        //      the body of the original time loops
        Stmt new_body = body;
        Expr signals_var = Variable::make(struct_type_for_signals, signals_var_name);
        for (int i = (int)(signals.size()) - 1; i >= 0; i--) {
            Type field_type = signals[i].first.type();
            Expr read_field = Call::make(field_type, Call::read_field, {signals_var, IntImm::make(Int(32), i)}, Call::PureIntrinsic);
            new_body = LetStmt::make(signals[i].second, read_field, new_body);
        }
        new_body = LetStmt::make(signals_var_name, Call::make(struct_type_for_signals, Call::read_channel, {StringImm::make(signal_generator_name + ".channel")}, Call::Intrinsic), new_body);
        return new_body;
    }

    Stmt create_signal_generator(const Stmt &s) {
        // The IR should look like this:
        // Realize SignalGenerator.channel
        //   Produce SignalGenerator
        //     parallel SignalGenerator.s0.run_on_device // Dummy loop to say the signal generator runs on the device
        //       for time loops
        //         signal0 = ...
        //         signal1 = ...
        //         write_channel(SignalGenerator.channel, {signal0, signal1})
        //   Consume SignalGenerator
        //     the run_forever kernel that consumes the signals
        internal_assert(!time_loops.empty());
        Stmt new_s;
        Expr signals_var = Variable::make(struct_type_for_signals, signals_var_name);
        vector<Expr> args;
        args.push_back(signal_generator_name + ".channel");
        args.push_back(signals_var);
        new_s = Evaluate::make(Call::make(struct_type_for_signals, Call::write_channel, args, Call::Intrinsic));

        vector<Expr> temporaries;
        for (size_t i = 0; i < signals.size(); i++) {
            Expr signal = Variable::make(signals[i].first.type(), signals[i].second);
            temporaries.push_back(signal);
        }
        new_s = LetStmt::make(signals_var_name, Call::make(struct_type_for_signals, Call::make_struct, temporaries, Call::PureIntrinsic), new_s);

        map<string, Expr> original_to_new_loops;
        for (auto l : time_loops) {
            string original_name = l->name;
            string new_name = signal_generator_name + "." + extract_after_tokens(original_name, 1);
            original_to_new_loops[original_name] = Variable::make(l->min.type(), new_name);
        }
        for (int i = (int)(signals.size()) - 1; i >= 0; i--) {
            Expr expr = signals[i].first;
            for (auto l : time_loops) {
                expr = substitute(l->name, original_to_new_loops[l->name], expr);
            }
            new_s = LetStmt::make(signals[i].second, expr, new_s);
        }
        for (int i = (int)(time_loops.size()) - 1; i >= 0; i--) {
            const For *original_loop = time_loops[i];
            // A loop's min/extent may reference outer loops' variables. Need replace these variables with new variables as well.
            Expr min = original_loop->min;
            Expr extent = original_loop->extent;
            for (auto l : time_loops) {
                min = substitute(l->name, original_to_new_loops[l->name], min);
                extent = substitute(l->name, original_to_new_loops[l->name], extent);
            }
            new_s = For::make(original_to_new_loops[original_loop->name].as<Variable>()->name, min, extent, original_loop->for_type, original_loop->device_api, new_s);
        }
        new_s = For::make(signal_generator_name + ".s0.run_on_device", 0, 1, ForType::Parallel, device_api, new_s);
        Stmt consumer = ProducerConsumer::make(signal_generator_name, false, s);
        Stmt producer = ProducerConsumer::make(signal_generator_name, true, new_s);
        Stmt producer_consumer = Block::make(producer, consumer);
        Stmt realize = Realize::make(signal_generator_name + ".channel", {struct_type_for_signals}, MemoryType::Auto, {Range(0, 256)}, const_true(), producer_consumer);

        // Create a Function for this signal generator.
        // NOTE: this function has no initial definition, which might cause issues later if treated as a normal function.
        Function f(signal_generator_name);
        f.place(Place::Device);
        env[signal_generator_name] = f;

        return realize;
    }

public:
    IsolateSignals(map<string, Function> &env) : env(env), in_run_forever_func(false), in_space_loops(false) { }

    Stmt visit(const ProducerConsumer *op) override {
        // The IR of a function is typically like:
        // Produce something // An arbitrary function
        //   ...
        // Consume something
        //   Realize F.channel  // We want to insert a signal generator as a producer of the function F above this statement
        //     Produce F
        //       parallel F.s0.run_on_device // Dummy loop to say the function runs on the device
        //         for time loops
        //           ...
        //     Consume F
        // Suppose we want to isolate signals of the run-forever function F. Then we want to catch the very first statement for the function (the Realize above),
        // and insert a signal generator above it.
        // Note that the Produce-Consume of functions are nesting.
        if (op->is_producer) {
            return IRMutator::visit(op);
        } else {
            // A previous function ends and a new function starts.
            // As the Consumes are nesting in the IR, let us record the current signals etc. (due to previous
            // functions). New signals etc. will appear due to the other functions to see in the IR.
            DeviceAPI                  prev_device_api = device_api;
            vector<const For *>        prev_time_loops(time_loops);
            vector<pair<Expr, string>> prev_signals(signals);
            Type                       prev_struct_type_for_signals = struct_type_for_signals;
            string                     prev_signals_var_name = signals_var_name;
            string                     prev_signal_generator_name = signal_generator_name;

            in_run_forever_func = false;
            in_space_loops = false;
            time_loops.clear();
            signals.clear();
            Stmt new_body = IRMutator::mutate(op->body); // The first statement of the op->body is, in general, something like the "Realize F.channel" above
            if (!signals.empty()) {
                // Create a signal generator that will produce the signals for this kernel
                new_body = create_signal_generator(new_body);
            }
            Stmt new_stmt = ProducerConsumer::make(op->name, false, new_body);

            // Recover the previous function's state
            device_api = prev_device_api;
            time_loops = prev_time_loops;
            signals = prev_signals;
            struct_type_for_signals = prev_struct_type_for_signals;
            signals_var_name = prev_signals_var_name;
            signal_generator_name = prev_signal_generator_name;

            return new_stmt;
        }
    }

    Stmt visit(const For *op) override {
        if (ends_with(op->name, ".run_on_device")) {
            string func_name = extract_first_token(op->name);
            if (run_forever(func_name)) {
                in_run_forever_func = true;
                run_forever_func_name = func_name;
                device_api = op->device_api;
                signals_var_name = unique_name("signals");
            }
            return IRMutator::visit(op);
        } else {
            if (op->for_type == ForType::DelayUnroll || op->for_type == ForType::Unrolled ||
                op->for_type == ForType::PragmaUnrolled || op->for_type == ForType::Vectorized) {
                bool old_in_space_loops = in_space_loops;
                in_space_loops = true;
                Stmt new_for = IRMutator::visit(op);
                in_space_loops = old_in_space_loops;
                return new_for;
            } else if (op->for_type == ForType::Serial) {
                // Time loops.
                user_assert(!in_run_forever_func || !in_space_loops) << "A time loop (" << op->name
                        << ") is found inside unrolled/vectorized loops in a function marked as run_forever (" << run_forever_func_name
                        << "). To make the function run forever, unrolled/vectorized loops must be at the innermost levels.";
                if (!in_run_forever_func) {
                    return IRMutator::visit(op);
                } else {
                    bool outermost_time_loop = time_loops.empty();
                    time_loops.push_back(op);
                    Stmt new_body = IRMutator::mutate(op->body);
                    // Check that the new body of the loop contains no reference to the loop variable: any expression using this loop
                    // should have been replaced by signals sent from the signal generator
                    CheckVarUsage checker(op->name);
                    new_body.accept(&checker);
                    internal_assert(!checker.used) << "Function " << run_forever_func_name << " cannot be made to run forever. "
                                                   << "Check if the loop variable " << op->name << " is used anywhere outside a condition in IfThenElse or Select.\n"
                                                   << "The problematic IR is as follows:\n" << to_string(new_body) << "\n";

                    if (outermost_time_loop) {
                        signal_generator_name = unique_name("SignalGenerator");

                        // Create a struct type including all the signals.
                        struct_type_for_signals = create_type_for_signals();

                        // Read signals sent from the signal generator.
                        new_body = create_reading_of_signals(new_body);

                        // Create a while(1) loop to replace all the time loops
                        Stmt infinite_loop = For::make(extract_first_token(op->name) + ".s0.infinite", 0, 10, ForType::Serial, op->device_api, new_body);
                        return infinite_loop;
                    } else {
                        // Just return the new body. This loop is effectively removed.
                        return new_body;
                    }
                }
            } else {
                return IRMutator::visit(op);
            }
        }
    }

    Stmt visit(const IfThenElse *op) override {
        if (in_run_forever_func) {
            Expr condition = op->condition;
            Expr new_condition = try_isolate(condition);
            return IfThenElse::make(new_condition, IRMutator::mutate(op->then_case), IRMutator::mutate(op->else_case));
        } else {
            return IRMutator::visit(op);
        }
    }

    Expr visit(const Select *op) override {
        if (in_run_forever_func) {
            Expr condition = op->condition;
            Expr new_condition = try_isolate(condition);
            return Select::make(new_condition, IRMutator::mutate(op->true_value), IRMutator::mutate(op->false_value));
        } else {
            return IRMutator::visit(op);
        }
    }

    Expr visit(const Let *op) override {
        name2value[op->name] = op->value;
        Expr new_op = IRMutator::visit(op);
        name2value.erase(op->name);
        return new_op;
    }

    Stmt visit(const LetStmt *op) override {
        name2value[op->name] = op->value;
        Stmt new_op = IRMutator::visit(op);
        name2value.erase(op->name);
        return new_op;
    }
};

Stmt isolate_signals(const Stmt &s, map<string, Function> &env) {
    IsolateSignals isolator(env);
    Stmt new_s = isolator.mutate(s);
    return new_s;
}

}
}
