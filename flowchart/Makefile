#example
DOCKER_COMPOSE_FILE := docker-compose.yml

build:
    docker-compose -f $(DOCKER_COMPOSE_FILE) build

up:
    docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
    docker-compose -f $(DOCKER_COMPOSE_FILE) down

restart:
    docker-compose -f $(DOCKER_COMPOSE_FILE) restart

test:
    docker-compose -f $(DOCKER_COMPOSE_FILE) run --rm test

logs:
    docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

.PHONY: build up down restart test logs
