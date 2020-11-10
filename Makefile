# https://lithic.tech/blog/2020-05/makefile-dot-env
# ifneq (,$(wildcard ./.env))
#     include .env
#     export
# endif

%:
    @:

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# constand
SERVICE_TARGET := backend
PROJECT_NAME := ts-backend-boilerplate
CONTAINER := $(shell docker ps -q --filter ancestor=$(PROJECT_NAME)_$(SERVICE_TARGET))

REMOTE_WORKDIR := /opt/app/

.PHONY: build
build: ## only build the container. Note, docker does this also if you apply other targets.
	# local dependencie
	# sudo npm i -g gnomon
	docker-compose build $(SERVICE_TARGET) | gnomon

.PHONY: rebuild
rebuild: ## force a rebuild by passing --no-cache
	docker-compose build --no-cache $(SERVICE_TARGET) | gnomon

.PHONY: start
start: ## run as a (background) service
	docker-compose up

.PHONY: service
service: ## run as a (background) service
	docker-compose up -d

.PHONY: stop
stop: ## down containers
	docker-compose down

.PHONY: login
login: ## run as a service and attach to it
	docker exec -it $(CONTAINER) bash

.PHONY: logs
logs: ## Follow containers logs
	docker-compose logs -f

.PHONY: test
test: ## run test into container
	docker exec -t \
	$(PROJECT_NAME)_$(SERVICE_TARGET)_1 \
	npm t

# for args https://stackoverflow.com/a/47008498/10660145
.PHONY: migration
migration: ## run test into container
	docker exec -t \
	$(PROJECT_NAME)_$(SERVICE_TARGET)_1 \
	npx knex migrate:make $(call args,migration_name)

# --- Utilities --
.PHONY: clean
clean: ## remove created images
	@docker-compose -p $(PROJECT_NAME) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'

.PHONY: help
help: ## Display this help screen
	@echo "Please use \`make <target>' where <target> is one of"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'
