#!/bin/sh

# Start the MariaDB service
mysqld_safe &

# Substitute environment variables in mariadb.cnf.template
envsubst < etc/mysql/mariadb.cnf.template > /etc/mysql/my.cnf

#set -e  # Exit immediately if a command exits with a non-zero status

# Initialize the database if necessary
#if ! mysql_install_db --user=mysql --datadir=/var/lib/mysql; then
#  echo "Error: Database initialization failed"
#  exit 1
#fi

# Ensure directory permissions
#if ! chown -R mysql:mysql /var/lib/mysql /run/mysqld /var/log/mysql; then
#  echo "Error: Failed to set directory permissions"
#  exit 1
#fi

# Start the MariaDB service
#if ! mysqld_safe &; then
#  echo "Error: Failed to start MariaDB service"
#  exit 1
#fi

# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done


# Keep the MariaDB server running in the foreground
mysqld_safe
