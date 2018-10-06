build:
	docker build -t oasis-server .

run:
	docker run -it -v ${PWD}:/oasis-server -p 5000:5000 --rm oasis-server


