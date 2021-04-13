local function perf_time(description, fn, result_cb, config) -- result_cb, config are optional
  -- warming up lua jit: configurable
  for i = 1, 100 do
    fn()
  end

  collectgarbage("stop") -- disabling gc: configurable
  ngx.update_time() -- making sure time is up to date: configurable

  local start = ngx.now() -- ms precision
  for i = 1, config.N do
    fn()
  end

  ngx.update_time() -- making sure time is up to date: configurable
  local elapsed_time =  (ngx.now() - start)/config.N -- we'd pass this value to result_cb: configurable
  print(":: " .. description .. " :: took " .. string.format("%.8f",elapsed_time) .. " seconds")
  collectgarbage("restart") -- re-enabling gc: configurable
end

local function perf_mem(description, fn, result_cb, config) -- result_cb, config are optional
  collectgarbage("stop") -- disabling gc: configurable
  local start = collectgarbage("count")

  fn()

  local used_memory_kb =  (collectgarbage("count") - start) -- we'd pass this value to result_cb: configurable
  print(":: " .. description .. " :: used " .. used_memory_kb .. " kb")
  collectgarbage("restart") -- re-enabling gc: configurable
end

local function mycode()
  local x = {}
  for i = 1, 1e3 do
    local now = ngx.now()
    now = now - 45 + i
    x[i] = now
  end
  return x
end

local N = 1e5 -- How many times should we run this test: configurable

perf_time("mycode cpu profiling", function()
   mycode()
end, nil, {N=N})

perf_mem("mycode memory profiling", function()
   mycode()
end, nil, {N=N})
