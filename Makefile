bench:
	docker run -it --rm -v ${PWD}/test.lua:/test.lua -v ${PWD}/lib/resty/perf.lua:/lib/resty/perf.lua openresty/openresty:xenial resty /test.lua

build-test:
	docker-compose build test

test:
	docker-compose run --rm test

lint:
	docker-compose run --rm lint

.PHONY: build up down build-test test
