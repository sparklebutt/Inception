#!/bin/sh

# Start the MariaDB service
mysqld_safe &

#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Initialize the database if necessary
if ! mysql_install_db --user=mysql --datadir=/var/lib/mysql; then
  echo "Error: Database initialization failed"
  exit 1
fi

# Ensure directory permissions
if ! chown -R mysql:mysql /var/lib/mysql /run/mysqld /var/log/mysql; then
  echo "Error: Failed to set directory permissions"
  exit 1
fi

# Start the MariaDB service
if ! mysqld_safe &; then
  echo "Error: Failed to start MariaDB service"
  exit 1
fi

# Wait for MariaDB to be ready
until mysqladmin ping --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# Initialize the database if necessary
#if [ -d "/docker-entrypoint-initdb.d" ]; then
#  echo "Initializing database..."
#  for f in /docker-entrypoint-initdb.d/*; do
#    case "$f" in
#      *.sh)  echo "$0: running $f"; . "$f" ;;
#      *.sql) echo "$0: running $f"; mysql < "$f"; echo ;;
#      *)     echo "$0: ignoring $f" ;;
#    esac
#    echo
#  done
#fi

# Keep the MariaDB server running in the foreground
mysqld_safe
