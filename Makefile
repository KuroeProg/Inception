# **************************************************************************** #
#                                   Makefile                                   #
# **************************************************************************** #

SRCS_DIR       := srcs
DOCKER_COMPOSE := docker-compose

DATA_DIRS  := $(SRCS_DIR)/requirements/mariadb/data \
              $(SRCS_DIR)/requirements/wordpress/data

# --------------------------------------------------------------------------- #
# Règles principales                                                          #
# --------------------------------------------------------------------------- #

all: up

up: $(DATA_DIRS)
	cd $(SRCS_DIR) && $(DOCKER_COMPOSE) build
	cd $(SRCS_DIR) && $(DOCKER_COMPOSE) up -d

down:
	cd $(SRCS_DIR) && $(DOCKER_COMPOSE) down

re: down up

# --------------------------------------------------------------------------- #
# Gestion des données                                                         #
# --------------------------------------------------------------------------- #

$(DATA_DIRS):
	mkdir -p $@

# --------------------------------------------------------------------------- #
# Nettoyage                                                                   #
# --------------------------------------------------------------------------- #

clean: down

fclean: clean
	rm -rf $(DATA_DIRS)

.PHONY: all up down re clean fclean
