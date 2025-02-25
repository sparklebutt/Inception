
#!/bin/sh

# Test if Nginx is up and running
curl -s http://nginx:80 | grep 'Hello, World!'
if [ $? -ne 0 ]; then
    echo "Test Failed: Nginx is not serving 'Hello, World!'"
    exit 1
fi

# Test if SSL/TLS certificate is being served correctly
curl -k -s --head https://nginx:443 | grep '200 OK'
if [ $? -ne 0 ]; then
    echo "Test Failed: SSL/TLS certificate not served correctly"
    exit 1
fi

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
echo "All tests passed successfully."

