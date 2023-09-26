#include "Expose.h"

namespace Halide {
Expose expose(const string &func_name, const vector<GetName> &parts) {
    Expose e{};
    e.func_name = func_name;
    for (const auto &part: parts) e.parts.insert(parts.name);
}
}
