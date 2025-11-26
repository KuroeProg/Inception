all: up

up:
	cd srcs && docker compose up -d
	cd srcs && docker compose build

down:
	cd srcs && docker compose down -v

re: down up