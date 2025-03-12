#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Substitute environment variables in mariadb.cnf.template
envsubst < etc/mysql/mariadb.cnf.template > /etc/mysql/my.cnf

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql /run/mysqld /var/log/mysql
# Ensure directory permissions
#if ! chown -R mysql:mysql /var/lib/mysql /run/mysqld /var/log/mysql; then
#  echo "Error: Failed to set directory permissions"
#  exit 1
#fi

mysqld_safe &
# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# Keep the MariaDB server running in the foreground exce?
exec mysqld_safe
