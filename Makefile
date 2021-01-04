.PHONY:start-raiden
start-raiden:
	docker-compose up -d

.PHONY:start-raiden2
start-raiden2:
	docker-compose up -d raiden1 raiden2

.PHONY:start-raiden1
start-raiden1:
	docker-compose up -d raiden1

.PHONY:stop-raiden
stop-raiden:
	docker-compose down

.PHONY:stop-raiden-hard
stop-raiden-hard:
	docker-compose down -v
