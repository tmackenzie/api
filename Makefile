

build:
	docker build -t api .
run:
	docker run --publish 8080:8080 api
