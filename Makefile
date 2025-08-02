all: prepare build
	docker compose -f srcs/docker-compose.yml up 

prepare:
	sudo mkdir -p /home/wzeraig/data/mariadb
	sudo mkdir -p /home/wzeraig/data/wordpress
	sudo chmod 777 /home/wzeraig/data/mariadb
	sudo chmod 777 /home/wzeraig/data/wordpress

down:
	docker compose -f srcs/docker-compose.yml down
	docker compose -f srcs/docker-compose.yml down -v

build: down
	docker compose -f srcs/docker-compose.yml build

purge: down
	sudo rm -rf /home/wzeraig/data/*
	docker system prune -af

.PHONY: all prepare down build purge
