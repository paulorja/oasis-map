build:
	docker build -t oasis-server .

run:
	docker-compose up

tests:
	docker-compose run oasis-server rspec
