FROM debian:bullseye

RUN apt update && apt install -y --no-install-recommends \
        php-fpm php-mysql curl tar ca-certificates \
    && mkdir -p /run/php /var/www/html \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz \
        && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
        && chown -R www-data:www-data /var/www/html \
        && rm /tmp/wordpress.tar.gz

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "php-fpm", "-F" ]

