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

#make restart for a quick application of new configs or recovery
restart:
    docker-compose -f $(DOCKER_COMPOSE_FILE) restart
#make test to run tests if we have any, we should
test:
    docker-compose -f $(DOCKER_COMPOSE_FILE) run --rm test
#assumin that we have a application that runs a web server returning "hello, World!"
    curl -s http://localhost | grep "Hello, World!"

#make logs to view logs of the running service in real time
logs:
    docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

.PHONY: build up down restart test logs
