#example
DOCKER_COMPOSE_FILE := srcs/docker-compose.yml

# make build to build the dockerfiles
#docker build -t custom-nginx ./nginx
#docker build -t custom-wordpress ./wordpress
#docker build -t custom-mariadb ./mariadb
build:
    docker-compose -f $(DOCKER_COMPOSE_FILE) build

#make up start service define in docker-compse.yml
up:
    docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

#make down stops and remove services //cleanup
down:
    docker-compose -f $(DOCKER_COMPOSE_FILE) down
# show status of contianers running managed by docker compose (only running)
# --all flag will show stopped containers as well
ps:
    docker-compose -f $(DOCKER_COMPOSE_FILE) ps

#make restart for a quick application of new configs or recovery
restart:
    docker-compose -f $(DOCKER_COMPOSE_FILE) restart
#make test to run tests if we have any, we should
test:
    docker-compose -f $(DOCKER_COMPOSE_FILE) run --rm test

#make logs to view logs of the running service in real time
logs:
    docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

#clean dangeling images and unused volumes
clean:
    docker system prune -f --volumes
   # docker volume prune -f --volumes

#View logs for a specific service (--env-file )
logs-nginx:
    docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f nginx
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Start Docker containers"
	@echo "  up        - Start Docker containers"
	@echo "  down      - Stop Docker containers"
	@echo "  clean     - Remove Docker containers"
	@echo "  ps        - Show Docker containers status"
	@echo "  logs      - Show Docker containers logs"
	@echo "  help      - Show this help message"

.PHONY: build up down restart test logs

#@echo "  fclean    - Remove Docker containers, networks, volumes, and images"
#@echo "  re        - Restart Docker containers"