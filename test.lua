package.path = package.path .. ";/lib/?.lua"

local perf = require "resty.perf"

local function mycode()
  local x = {}
  for i = 1, 1e3 do
    local now = ngx.now()
    now = now - 45 + i
    x[i] = now
  end
  return x
end

perf.perf_time("mycode cpu profiling", function()
   mycode()
end)

perf.perf_mem("mycode memory profiling", function()
   mycode()
end)
