#!/bin/sh
set -e

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
POOL_CONF="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"

if [ -f "$POOL_CONF" ]; then
  sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' "$POOL_CONF"

  if ! grep -q '^clear_env = no' "$POOL_CONF"; then
    echo 'clear_env = no' >> "$POOL_CONF"
  fi
fi

if [ ! -f /var/www/html/wp-config.php ]; then
  if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_HOST" ]; then
    echo "❌ MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD et MYSQL_HOST doivent être définies"
    exit 1
  fi

  echo "➡ Génération de wp-config.php..."
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
  sed -i "s/localhost/${MYSQL_HOST}/" /var/www/html/wp-config.php

  if ! grep -q "FS_METHOD" /var/www/html/wp-config.php; then
    printf "\ndefine( 'FS_METHOD', 'FS_METHOD', 'direct' );\n" >> /var/www/html/wp-config.php
  fi

  chown www-data:www-data /var/www/html/wp-config.php
fi

echo "➡ Démarrage de php-fpm..."

if command -v php-fpm >/dev/null 2>&1; then
  exec php-fpm -F
else
  exec php-fpm${PHP_VERSION} -F
fi