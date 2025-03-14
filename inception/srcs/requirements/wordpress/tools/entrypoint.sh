#!/bin/sh

set -e

envsubst < /etc/php83/php-fpm.d/www.conf.template > /etc/php83/php-fpm.d/www.conf

echo "Testing database connection..."
echo "WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST}"

until mysql -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "USE ${WORDPRESS_DB_NAME};"; do
  echo "waiting for database connection .....!"
  sleep 10
done

echo "Database connection successful."

if ! wp core is-installed --path="/var/www/html"; then
  echo "WordPress is being installed"

  if ! wp core download --path=/var/www/html; then
    echo "Error downloading WordPress"
    exit 1
  fi

  if ! wp config create --dbname="${MYSQL_DATABASE}" --dbuser="${MYSQL_USER}" --dbpass="${MYSQL_PASSWORD}" --dbhost="${DB_HOST}" --path=/var/www/html; then
    echo "Error creating wp-config.php"
    exit 1
  fi

  if ! wp core install --url="http://localhost" --title="WordPress Site" --admin_user="${ADMIN_UNAME}" --admin_password="${BOSS_PASS}" --admin_email="admin@example.com" --skip-email --path=/var/www/html; then
    echo "Error installing WordPress"
    exit 1
  fi

  if ! wp user create "${GUEST_UNAME}" user@example.com --user_pass="${GUEST_PASS}" --role=editor --path=/var/www/html; then
    echo "Error creating additional user"
    exit 1
  fi
else
  echo "WordPress is already installed."
fi

chown -R www-data:www-data /var/www/html

exec php-fpm -F
