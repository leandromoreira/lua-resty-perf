local _M     = {
    _VERSION = "1.0.4-0",
    _AUTHOR  = "Leandro Moreira",
    _LICENSE = "BSD-3-Clause License",
    _URL     = "https://github.com/leandromoreira/lua-resty-perf",
}

local _update_time = function()
end
local _now = function()
  return os.clock()
end

-- when available, it uses openresty env
if ngx then
  if ngx.update_time then
    _update_time = ngx.update_time
  end

  if ngx.now then
    _now = ngx.now
  end
end

_M.setup = function(opts)
  opts = opts or {}
  _M.result_cb               = opts.result_cb or _M.result_cb
  _M.luajit_warmup_loop      = opts.luajit_warmup_loop or _M.luajit_warmup_loop
  _M.disable_gc_during_tests = opts.disable_gc_during_tests or _M.disable_gc_during_tests
  _M.N                       = opts.N or _M.N
  _M.now                     = opts.now or _M.now
  _M.update_time             = opts.update_time or _M.update_time
end

_M.default_opt = function()
  local opts = {}
  opts.result_cb = function(value, fmt_msg) -- function called after the test, its default behavior is to print to the sdtdout
    print(string.format(fmt_msg, value))
  end
  opts.luajit_warmup_loop = 100 -- the number of execution to promote the code for the jit
  opts.disable_gc_during_tests = true -- disable gc during tests
  opts.N = 1e5 -- times to run the tests
  opts.now = _now
  opts.update_time = _update_time
  return opts
end

-- setting the default options
_M.setup(_M.default_opt())

_M.perf_time = function(description, fn, result_cb, config)
  if description == nil then error("perf_time(description, fn): you must pass the description") end
  if fn == nil then error("perf_time(description, fn): you must pass the function") end
  if type(description) ~= "string" or type(fn) ~= "function" then error("perf_time(description, fn): description is a string and fn is a function") end

  config = config or {}
  result_cb = result_cb or config.result_cb or _M.result_cb
  local jit_loop = config.luajit_warmup_loop or _M.luajit_warmup_loop
  local disable_gc = config.disable_gc_during_tests or _M.disable_gc_during_tests
  local N = config.N or _M.N
  local update_time = config.update_time or _M.update_time
  local now = config.now or _M.now

  -- warming up lua jit
  for _ = 1, jit_loop do
    fn()
  end

  if disable_gc then collectgarbage("stop") end
  -- making sure time is up to date
  update_time()

  local start = now() -- ms precision
  for _ = 1, N do
    fn()
  end

  update_time()

  result_cb((now() - start)/N, ":: " .. description .. " :: took %.8f seconds per operation")

  if disable_gc then collectgarbage("restart") end
end

_M.perf_mem = function(description, fn, result_cb, config) -- result_cb, config are optional
  if description == nil then error("perf_mem(description, fn): you must pass the description") end
  if fn == nil then error("perf_mem(description, fn): you must pass the function") end
  if type(description) ~= "string" or type(fn) ~= "function" then error("perf_mem(description, fn): description is a string and fn is a function") end

  config = config or {}
  result_cb = result_cb or config.result_cb or _M.result_cb

  collectgarbage("stop") -- disabling gc
  local start = collectgarbage("count")

  fn()

  result_cb(collectgarbage("count") - start, ":: " .. description .. " :: used %d kb")
  collectgarbage("restart") -- re-enabling gc
end

return _M
