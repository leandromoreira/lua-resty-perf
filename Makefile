bench:
	docker run -it --rm -v ${PWD}/test.lua:/test.lua -v ${PWD}/lib/resty/perf.lua:/lib/resty/perf.lua openresty/openresty:xenial resty /test.lua
