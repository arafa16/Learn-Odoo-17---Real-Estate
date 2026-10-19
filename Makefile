WEB_DB_NAME = odoo_development
DOCKER = docker
DOCKER_COMPOSE = $(DOCKER) compose
CONTAINER_ODOO = odoo
CONTAINER_DB = odoo-postgres

.PHONY: help

help:
	@echo "Available targets:"
	@echo "  start		Start the compose with daemon"
	@echo "  stop		Stop the compose"
	@echo "  restart	Restart the compose"
	@echo "  console	Odoo interactive console"
	@echo "  psql		PostgreSQL interactive shell"
	@echo "  logs odoo	Logs the odoo container"
	@echo "  logs db	Logs the postgresql container"

start:
	$(DOCKER_COMPOSE) up -d
stop:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart

console:
	$(DOCKER) exec -it $(CONTAINER_ODOO) odoo shell --db_host=$(CONTAINER_DB) -d $(WEB_DB_NAME) -r $(CONTAINER_ODOO) -w $(CONTAINER_ODOO)
psql:
	$(DOCKER) exec -it $(CONTAINER_DB) psql -U $(CONTAINER_ODOO) -d $(WEB_DB_NAME)


logs:
	@if [ "$(word 2,$(MAKECMDGOALS))" = "odoo" ]; then \
		$(DOCKER_COMPOSE) logs -f $(CONTAINER_ODOO); \
	elif [ "$(word 2,$(MAKECMDGOALS))" = "db" ]; then \
		$(DOCKER_COMPOSE) logs -f $(CONTAINER_DB); \
	else \
		echo "Usage: make logs odoo OR make logs db"; \
		exit 1; \
	fi
odoo db:
	@:

.PHONY: start stop restart console psql logs odoo db
