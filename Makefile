

build:
	docker build -t api .
run:
	docker run -p 8080:8080 -e PORT=8080 api
