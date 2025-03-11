
#!/bin/sh

# Test if Nginx is up and running
#curl -s http://nginx:80 | grep 'Hello, World!'
#if [ $? -ne 0 ]; then
#    echo "Test Failed: Nginx is not serving 'Hello, World!'"
#    exit 1

#fi
#must make a html file for that test


# Test if HTTP is redirected to HTTPS
curl -s -o /dev/null -w '%{http_code}' http://nginx:80 | grep '301'
if [ $? -ne 0 ]; then
    echo "Test Failed: HTTP not redirected to HTTPS"
    exit 1
fi

# Ensure Nginx configuration is correct and is being used
docker-compose -f srcs/docker-compose.yml exec nginx cat /etc/nginx/nginx.conf | grep 'server_name'
if [ $? -ne 0 ]; then
    echo "Test Failed: Nginx configuration is incorrect or not being used"
    exit 1
fi
echo "All nginx tests passed successfully."

# Test if WordPress home page is up and running
curl -s http://nginx:80 | grep 'Welcome to WordPress'
if [ $? -ne 0 ]; then
    echo "Test Failed: WordPress home page not served correctly"
    exit 1
fi

# Test if WordPress login page is accessible
curl -s http://nginx:80/wp-login.php | grep 'Log In'
if [ $? -ne 0 ]; then
    echo "Test Failed: WordPress login page not accessible"
    exit 1
fi

# Test database connection via WordPress
docker-compose -f srcs/docker-compose.yml exec wordpress wp db check --path=/var/www/html
if [ $? -ne 0 ]; then
    echo "Test Failed: WordPress cannot connect to the database"
    exit 1
fi

# Test if PHP-FPM is running
docker-compose -f srcs/docker-compose.yml exec wordpress ps aux | grep php-fpm | grep -v grep
if [ $? -ne 0 ]; then
    echo "Test Failed: PHP-FPM is not running"
    exit 1
fi

# Test if WordPress directory has correct permissions
docker-compose -f srcs/docker-compose.yml exec wordpress ls -ld /var/www/html | grep 'www-data'
if [ $? -ne 0 ]; then
    echo "Test Failed: WordPress directory permissions are incorrect"
    exit 1
fi

# Test if SSL/TLS certificate is being served correctly
curl -k -s --head https://nginx:443 | grep '200 OK'
if [ $? -ne 0 ]; then
    echo "Test Failed: SSL/TLS certificate not served correctly"
    exit 1
fi
