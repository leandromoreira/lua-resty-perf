# Resty Perf

A simple resty lua library to benchmark memory and throughput of a function.

```lua
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
```
It'll show:
```bash
:: mycode cpu profiling :: took 0.00000818 seconds per operation
:: mycode memory profiling :: used 8 kb
```
