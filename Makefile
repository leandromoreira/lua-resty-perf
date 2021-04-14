bench:
	docker run -it --rm -v ${PWD}/example.lua:/example.lua -v ${PWD}/lib/resty/perf.lua:/lib/resty/perf.lua openresty/openresty:xenial resty /example.lua

build-test:
	docker-compose build test

test:
	docker-compose run --rm test

lint:
	docker-compose run --rm lint

.PHONY: build up down build-test test
