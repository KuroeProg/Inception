FROM debian:bullseye

# 1. Installer nginx et ajuster nginx config to stay in foreground
RUN apt-get update && apt-get install -y --no-install-recommends mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# 2. Génération du certificat (gardez la ligne actuelle, elle est correcte)
RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 3. Exposer le port 443
EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "mysqld", "--user=mysql", "--console" ]


