local _M     = {
    _VERSION = "1.0.0",
    _AUTHOR  = "Leandro Moreira",
    _LICENSE = "BSD-3-Clause License",
    _URL     = "https://github.com/leandromoreira/lua-resty-perf",
}

local ngx_update_time = ngx.update_time
local ngx_now = ngx.now

_M.new = function(opts)
  opts = opts or {}
   _M.result_cb               = opts.result_cb or function(value, fmt_msg) -- function called after the test, its default behavior is to print to the sdtdout
      print(string.format(fmt_msg, value))
    end
   _M.luajit_warmup_loop      = opts.luajit_warmup_loop or 100 -- the number of execution to promote the code for the jit
   _M.disable_gc_during_tests = opts.disable_gc_during_tests or true -- disable gc during tests
   _M.N                       = opts.N or 1e5 -- times to run the tests
   return _M
end

_M.perf_time = function(description, fn, result_cb, config)
  if description == nil then error("perf_time(description, fn): you must pass the description") end
  if fn == nil then error("perf_time(description, fn): you must pass the function") end
  if type(description) ~= "string" or type(fn) ~= "function" then error("perf_time(description, fn): description is a string and fn is a function") end

  config = config or {}
  result_cb = result_cb or config.result_cb or _M.result_cb
  local jit_loop = config.luajit_warmup_loop or _M.luajit_warmup_loop
  local disable_gc = config.disable_gc_during_tests or _M.disable_gc_during_tests
  local N = config.N or _M.N

  -- warming up lua jit
  for i = 1, jit_loop do
    fn()
  end

  if disable_gc then collectgarbage("stop") end
  -- making sure time is up to date
  ngx_update_time()

  local start = ngx_now() -- ms precision
  for i = 1, N do
    fn()
  end

  ngx_update_time()
  local elapsed_time =   -- we'd pass this value to result_cb: configurable

  result_cb((ngx.now() - start)/N, ":: " .. description .. " :: took %.8f seconds")

  if disable_gc then collectgarbage("restart") end
end

_M.perf_mem = function(description, fn, result_cb, config) -- result_cb, config are optional
  if description == nil then error("perf_mem(description, fn): you must pass the description") end
  if fn == nil then error("perf_mem(description, fn): you must pass the function") end
  if type(description) ~= "string" or type(fn) ~= "function" then error("perf_mem(description, fn): description is a string and fn is a function") end

  config = config or {}
  collectgarbage("stop") -- disabling gc
  result_cb = result_cb or config.result_cb or _M.result_cb

  local start = collectgarbage("count")

  fn()

  result_cb(collectgarbage("count") - start, ":: " .. description .. " :: used %d kb")
  collectgarbage("restart") -- re-enabling gc
end

return _M
