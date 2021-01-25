.PHONY: start-dev
rebuild-dev:
	docker-compose build

.PHONY: start-dev
start-dev:
	docker-compose -p hasura up -d
	./hasura/waitForHasuraPort.sh
	cd hasura && hasura migrate apply --envfile ../.env

.PHONY: hasura-logs
hasura-logs:
	docker logs hasura_graphql-engine_1 -f

.PHONY: stop-dev
stop-dev:
	docker-compose -p hasura down

.PHONY: stop-dev
hard-restart-dev:
	docker-compose -p hasura down -v
	make start-dev

.PHONY: restart-dev
restart-dev:
	make stop-dev
	make start-dev
