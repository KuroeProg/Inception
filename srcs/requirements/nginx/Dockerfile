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

RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
    	-keyout /etc/nginx/ssl/nginx.key \
    	-out /etc/nginx/ssl/nginx.crt \
    	-subj "/C=FR/ST=P/L=Perpignan/O=42Perpignan/OU=Inception/CN=cfiachet.42.fr"

EXPOSE 443

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]