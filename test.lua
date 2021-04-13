package.path = package.path .. ";/lib/resty/?.lua"

local perfresty = require "perf"

local function mycode()
  local x = {}
  for i = 1, 1e3 do
    local now = ngx.now()
    now = now - 45 + i
    x[i] = now
  end
  return x
end

local perf = perfresty.new()

perf.perf_time("mycode cpu profiling", function()
   mycode()
end)

perf.perf_mem("mycode memory profiling", function()
   mycode()
end)
