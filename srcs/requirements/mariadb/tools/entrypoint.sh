#!/bin/sh
set -e

# 0. Vérif des variables obligatoires
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "❌ Variables MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD requises"
    exit 1
fi

CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"

# 1. Forcer MariaDB à écouter sur toutes les interfaces
if [ -f "$CONF_FILE" ]; then
    echo "➡ Configuration de bind-address dans $CONF_FILE"
    sed -i 's/^[#[:space:]]*bind-address[[:space:]]*=.*/bind-address = 0.0.0.0/' "$CONF_FILE"
fi

# 2. Initialisation des tables système si besoin
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "➡ Initialisation de MariaDB (mysql_install_db)..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    echo "✅ Initialisation des tables système terminée."
fi

# 3. (Re)configuration systématique du root + DB + user applicatif
echo "➡ Configuration de la base '${MYSQL_DATABASE}' et de l'utilisateur '${MYSQL_USER}'..."

mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;

-- root local avec mot de passe défini par \$MYSQL_ROOT_PASSWORD
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- base WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

-- utilisateur applicatif accessible depuis n'importe où (tous les conteneurs Docker)
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "✅ Configuration de la base et des utilisateurs terminée."
echo "➡ Démarrage de MariaDB..."

exec mysqld --user=mysql --console