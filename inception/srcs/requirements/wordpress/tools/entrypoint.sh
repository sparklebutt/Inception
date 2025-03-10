
#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Wait for the database to be ready
until mysqladmin ping -h ${DB_HOST} --silent; do
  echo "Waiting for database to be ready..."
  sleep 2
done

# Check if WordPress is already installed The wp core is-installed command
# directly checks if WordPress is installed by querying the database, providing a precise and reliable status.
# creating the users here allows for dynamic user creation , eg differenmt system have different users.

if ! $(wp core is-installed --path="/var/www/html"); then
  echo "WordPress is being installed"

  # Download WordPress core files
  if ! wp core download --path=/var/www/html; then
    echo "Error downloading WordPress"
    exit 1
  fi

  # Create WordPress configuration file
  if ! wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${DB_HOST} --path=/var/www/html; then
    echo "Error creating wp-config.php"
    exit 1
  fi

  # Install WordPress
  if ! wp core install --url="http://localhost" --title="WordPress Site" --admin_user=${ADMIN_UNAME} --admin_password=${BOSS_PASS} --admin_email="admin@example.com" --skip-email --path=/var/www/html; then
    echo "Error installing WordPress"
    exit 1
  fi

  # Create additional user
  if ! wp user create ${GUEST_UNAME} user@example.com --user_pass=${GUEST_PASS} --role=editor --path=/var/www/html; then
    echo "Error creating additional user"
    exit 1
  fi
else
  echo "WordPress is already installed."
fi

# Ensure directory permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM in the foreground
php-fpm -F
