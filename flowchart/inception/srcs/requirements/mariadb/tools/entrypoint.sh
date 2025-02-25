#!/bin/sh

# Start the MariaDB service
mysqld_safe &

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
