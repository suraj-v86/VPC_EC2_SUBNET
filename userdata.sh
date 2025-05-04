#!bin/bash

# update the system
sudo apt update && sudo apt install upgrade -y

# install Apache HTTP Server
sudo apt install -y apache2

# start the Apache server
sudo systemctl start apache2
sudo systemctl enable apache2


# Remove the default index.html if it exists
sudo rm -f /var/www/html/index.html


# create an index.html file

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello, World! My name is Suraj and this is my first project in Python!!!</h1>
</body>
</html>


EOF

# Adjust permission
sudo chown -R www-data:www-data /var/www/html

# Restart the Apache server
sudo systemctl restart apache2
