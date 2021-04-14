package.path = package.path .. ";lib/?.lua;spec/?.lua"

-- in your code you should use: local perf = require "lua-resty-perf"
local perf = require "resty.perf"

local function mycode()
  local x = {}
  local now = os.time()
  for i = 1, 1e1 do
    now = now - 45 + i
    x[i] = now
  end
  os.execute("sleep " .. tonumber(0.001))
  return x
end


describe("Lua Resty Perf", function()
  it("run memory and cpu profilling", function()
    perf.perf_time("mycode cpu profiling", function()
      mycode()
    end, nil, {N=1e3})

    perf.perf_mem("mycode memory profiling", function()
      mycode()
    end, nil, {N=1e3})
  end)
end)
