.PHONY:start-raiden
start-raiden:
	docker-compose up -d

.PHONY:start-raiden2
start-raiden2:
	docker-compose up -d raiden1 raiden2

.PHONY:start-raiden1
start-raiden1:
	docker-compose up -d raiden1
