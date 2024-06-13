#include "Expose.h"
#include "Stensor.h"

namespace Halide {

namespace Internal {
GetName::GetName(const Stensor &s) : name(s.name) {};
GetName::GetName(const URE &u) {
    user_assert(!(u.function().definition().schedule().is_merged())) << "Can't expose func that has already been merged.\n";
    if (u.function().has_merged_defs()) {
        name = u.function().merged_func_names().back();
    } else {
        name = u.name();
    }
};
}

Expose expose(const string &func_name, const vector<Internal::GetName> &parts) {
    Expose e{};
    e.func_name = func_name;
    for (const auto &part: parts) e.parts.insert(part.name);
    return e;
}
}
