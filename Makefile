bench:
	docker run -it --rm -v ${PWD}/test.lua:/test.lua openresty/openresty:xenial resty /test.lua
