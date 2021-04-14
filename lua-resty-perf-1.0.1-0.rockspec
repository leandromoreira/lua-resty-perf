package = "lua-resty-perf"
version = "1.0.1-0"
source = {
  url = "git://github.com/leandromoreira/lua-resty-perf",
  tag = "1.0.1"
}
description = {
  summary  = "A simple resty lua library to benchmark memory and throughput of a function.",
  detailed = [[
  Lua Resty Perf is a simple resty lua library to benchmark memory and throughput of a function.
  ]],
  homepage = "https://github.com/leandromoreira/lua-resty-perf",
  license  = "BSD-3-Clause License "
}
build = {
  type    = "builtin",
  modules = {
    ["resty.perf"] = "lib/resty/perf.lua"
  }
}
