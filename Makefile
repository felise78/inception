.ONESHELL:

override docker_compose := docker-compose
override docker := docker
override data := /home/hemottu/data
override wordpress_dir := $(data)/wordpress
override        db_dir := $(data)/db
override        docker_compose_file := ./srcs/docker-compose.yml

.PHONY: all build up start stop down restart clean dblog dbex wplog wpex nglog ngex info ascii

all: ascii build 
	
$(wordpress_dir) $(db_dir):
	mkdir -p $@

build: | $(wordpress_dir) $(db_dir) 
	@echo '\033[32mB U I L D\033[0m'
	$(docker_compose) -f $(docker_compose_file) build

up: ascii build
	@echo '\033[32mU P\033[0m'
	$(docker_compose) -f $(docker_compose_file) up -d

start:
	@$(docker_compose) -f $(docker_compose_file) start

stop:
	@$(docker_compose) -f $(docker_compose_file) stop

down:
	@$(docker_compose) -f $(docker_compose_file) down -v

restart :
	@$(docker_compose) -f $(docker_compose_file) stop
	sleep 1
	@$(docker_compose) -f $(docker_compose_file) start

clean: down
	@-docker rmi $$(docker images -q) 2>/dev/null
	docker image prune -f
	docker container prune -f
	docker volume prune -f
	docker network prune -f
	docker system prune -f --volumes
	sudo rm -rf $(data)

# ----- DEBUG

dblog:
	@docker logs $(shell docker ps | grep mariadb | head -c 12)

dbex:
	@docker exec -it $(shell docker ps | grep mariadb | head -c 12) /bin/bash

wplog:
	@docker logs $(shell docker ps | grep wordpress | head -c 12)

wpex:
	@docker exec -it $(shell docker ps | grep wordpress | head -c 12) /bin/bash

nglog:
	@docker logs $(shell docker ps | grep nginx | head -c 12)

ngex:
	@docker exec -it $(shell docker ps | grep nginx | head -c 12) /bin/bash

# ---------

# ----- PRINT

info:
	@docker images && docker ps -a && docker network ls && docker volume ls

ascii:
	@echo '\033[38;2;226;196;245m'
	cat ascii
	echo '\033[0m'

# ----- NOTES

# up : will create the containers if they don't exist 
# start : only start containers that have been stoped but will not 
# create them

# down : stop and delete containers and the network linked to the .yml
# -v: delete also the volumes 

# flag -f : $(docker_compose) -f : to specify the file
# docker image prune -f : force 

# sudo rm -rfv $(data) : -v : verbose : print all the deleted files