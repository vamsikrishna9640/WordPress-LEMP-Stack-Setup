#!/bin/bash

# Function to check if a package is installed
check_package() {
  if ! dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "ok installed"; then
    return 1
  fi
  return 0
}

# Function to install a package
install_package() {
  echo "Installing $1..."
  sudo apt-get -qq install "$1"
}

# Check if docker is installed
if ! check_package docker; then
  echo "Docker is not installed. Installing Docker..."
  install_package docker
fi

# Check if docker-compose is installed
if ! check_package docker-compose; then
  echo "Docker Compose is not installed. Installing Docker Compose..."
  install_package docker-compose
fi

# Create a LEMP stack for WordPress site
create_wordpress_site() {
  if [ -z "$1" ]; then
    echo "Please provide a site name as an argument."
    exit 1
  fi

  #creating required files
mkdir "$1"
cd "$1"
# Creating public and nginx
echo "Creating nginx configuration file"
mkdir public nginx
cd nginx
cat > default.conf << EOF
events {}
http{
    server {
        listen 80;
        server_name $1;
        root /usr/share/nginx/html;
        index  index.php index.html index.html;

        location / {
            try_files $uri $uri/ /index.php?$is_args$args;
        }

        location ~ \.php$ {
            # try_files $uri =404;
            # fastcgi_pass unix:/run/php-fpm/www.sock;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass phpfpm:9000;
            fastcgi_index   index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }
} 
EOF
echo "Done"
echo "Creating index.php file in public"
cd ..
cd public
cat > index.php << EOF
<?php
phpinfo();
EOF
echo "Done"
cd ..
echo "Creating docker-compose file ..."
cat > docker-compose.yml << EOF 
version: '3'

services:
  #databse
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: password
    networks:
      - wpsite
  #php-fpm
  phpfpm:
    image: php:fpm
    depends_on:
      - db
    ports:
      - '9000:9000'
    volumes: ['./public:/usr/share/nginx/html']
    networks:
      - wpsite
  #phpmyadmin
  phpmyadmin:
    depends_on:
      - db
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
      - '8080:80'
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: password
    networks:
      - wpsite
  #wordpress
  wordpress:
    depends_on: 
      - db
    image: wordpress:latest
    restart: always
    ports:
      - '80:80'
    volumes: ['./:/var/www/html']
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    networks:
      - wpsite
  #nginx
  proxy:
    image: nginx:1.17.10
    depends_on:
      - db
      - wordpress
      - phpmyadmin
      - phpfpm
    ports:
      - '8001:80'
    volumes: 
      - ./:/var/www/html
      - ./nginx/default.conf:/etc/nginx/nginx.conf
    networks:
      - wpsite
networks:
  wpsite:
volumes:
  db_data:
EOF
echo "Done"
fuser -k 8000/tcp 9000/tcp 8081/tcp 8080/tcp

  # Start the containers
  docker-compose up -d

  # Add /etc/hosts entry
  echo "Adding /etc/hosts entry..."
  echo "127.0.0.1    $1" | sudo tee -a /etc/hosts

  echo "WordPress site created successfully. You can access it at http://$1"
}

# Function to enable/disable the site
enable_disable_site() {
  if [ -z "$1" ]; then
    echo "Please provide a site name as an argument."
    exit 1
  fi

  echo "Enabling/Disabling site: $1"

  cd "$1"

  if [ "$2" = "enable" ]; then
    docker-compose start
  elif [ "$2" = "disable" ]; then
    docker-compose stop
  else
    echo "Invalid command. Usage: $0 enable|disable site_name"
    exit 1
  fi

  echo "Site $1 has been $2d."
}

# Function to delete the site
delete_site() {
  if [ -z "$1" ]; then
    echo "Please provide a site name as an argument."
    exit 1
  fi

  echo "Deleting site: $1"

  cd "$1"

  # Stop and remove the containers
  docker-compose down

  # Remove the site directory
  cd ..
  rm -rf "$1"

  # Remove the /etc/hosts entry
  echo "Removing /etc/hosts entry..."
  sudo sed -i "/^127\.0\.0\.1[[:space:]]*$1$/d" /etc/hosts

  echo "Site $1 has been deleted."
}

# Main script

# Check the command-line arguments
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 create|enable|disable|delete site_name"
  exit 1
fi

command="$1"
site_name="$2"

case "$command" in
  create)
    create_wordpress_site "$site_name"
    ;;
  enable|disable)
    enable_disable_site "$site_name" "$command"
    ;;
  delete)
    delete_site "$site_name"
    ;;
  *)
    echo "Invalid command. Usage: $0 create|enable|disable|delete site_name"
    exit 1
    ;;
esac
