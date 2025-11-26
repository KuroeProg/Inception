# # Pull base image
# FROM debian:latest

# # Install nginx and adjust nginx config to stay in foreground
# RUN apt-get update && apt-get install --no-install-recommends nginx -y && apt-get install openssl -y

# RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
#     -keyout /etc/nginx/ssl/nginx.key \
#     -out /etc/nginx/ssl/nginx.crt \
#     -subj "/C=FR/ST=PO/L=Perpignan/O=42Perpignan/OU=Inception/CN=cfiachet.42.fr"

# # Expose HTTP
# EXPOSE 443

# # COPY conf/nginx.conf /etc/nginx/sites-available/default
# COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# # Start nginx
# CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# src/requirements/nginx/Dockerfile

FROM debian:bullseye

# 1. Installer nginx et ajuster nginx config to stay in foreground
RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# 2. Génération du certificat (gardez la ligne actuelle, elle est correcte)
RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
    	-keyout /etc/nginx/ssl/nginx.key \
    	-out /etc/nginx/ssl/nginx.crt \
    	-subj "/C=FR/ST=P/L=Perpignan/O=42Perpignan/OU=Inception/CN=cfiachet.42.fr"

# 3. Exposer le port 443
EXPOSE 443

# 4. Copier la configuration NGINX au bon endroit
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# 5. Démarrer nginx avec le chemin complet
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]