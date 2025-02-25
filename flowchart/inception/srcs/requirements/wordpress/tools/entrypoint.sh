
#!/bin/sh

# Wait for the database to be ready
until mysqladmin ping -h ${DB_HOST} --silent; do
  echo "Waiting for database to be ready..."
  sleep 2
done

# Check if WordPress is already installed The wp core is-installed command
# directly checks if WordPress is installed by querying the database, providing a precise and reliable status.
# creating the users here allows for dynamic user creation , eg differenmt system have different users.
if ! $(wp core is-installed --path="/var/www/html"); then
	echo "Wordpress being installed"
  # Download WordPress core files
  wp core download --path=/var/www/html

  # Create WordPress configuration file
  wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${DB_HOST} --path=/var/www/html

  # Install WordPress
  wp core install --url="http://localhost" --title="WordPress Site" --admin_user=${ADMIN_UNAME} --admin_password=${BOSS_PASS} --admin_email="admin@example.com" --skip-email --path=/var/www/html
  
  # Create additional user
  wp user create ${GUEST_UNAME} user@example.com --user_pass=${GUEST_PASS} --role=editor --path=/var/www/html
fi

# Start PHP-FPM in the foreground
php-fpm -F