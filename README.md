# rtCamp-Assignment
# WordPress LEMP Stack Setup

This script automates the setup of a LEMP (Linux, Nginx, MySQL, PHP) stack for hosting WordPress websites using Docker and Docker Compose. It creates a basic WordPress site with Nginx as the web server, MySQL as the database server, and PHP-FPM for PHP processing. It also includes phpMyAdmin for managing the MySQL database.

## Prerequisites

- Linux-based operating system (tested on Ubuntu)


## Installation

1. Clone the repository to your local machine:

   ```bash
    git clone https://github.com/vamsikrishna9640/rtCamp-Assignment.git
   ```

2. Change into the project directory:

   ```bash
   cd rtCamp-Assignment
   ```

3. Make the script executable:

   ```bash
   chmod +x wordpress.sh
   ```

## Usage

The given script is a bash script that can be used to create, enable, disable, and delete WordPress sites using Docker and Docker Compose. Here's a breakdown of the script:

1. The script starts by defining two functions: `check_package` and `install_package`. These functions are used to check if a package is installed and install a package using `apt-get` if it's not already installed.
  ```
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
  ```


2. Next, the script checks if Docker and Docker Compose are installed by calling the `check_package` function. If they are not installed, it proceeds to install them using the `install_package` function.
  ```
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
 ```
 

3. After ensuring that Docker and Docker Compose are installed, the script defines the `create_wordpress_site` function. This function creates a WordPress site using Docker Compose. It generates a `docker-compose.yml` file with Nginx, PHP, and MySQL services configured and creates the necessary directories and configuration files.
 ```
   # Create a LEMP stack for WordPress
  create_wordpress_site() {
  if [ -z "$1" ]; then
    echo "Please provide a site name as an argument."
    exit 1
  fi

 ```
 
 ```
 #ngnix config File
    events {}
http{
    server {
        listen 80;
        server_name $host;
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

 ```
 
 

4. The `enable_disable_site` function is used to enable or disable a WordPress site. It starts or stops the Docker containers associated with the site depending on the provided command.

5. The `delete_site` function deletes a WordPress site by stopping and removing the Docker containers and deleting the associated directories.

6. Finally, the main script validates the command-line arguments and calls the appropriate function based on the provided command (`create`, `enable`, `disable`, or `delete`) and the site name.

To use this script, you can save it to a file (e.g., `wordpress.sh`), make it executable (`chmod +x wordpress.sh`), and then run it with the desired command and site name as arguments. For example:

```
./wordpress.sh create example.com
```

This will create a new WordPress site with the name "example.com".
![image](https://github.com/vamsikrishna9640/rtCamp-Assignment/assets/91549516/169f0bd7-08d2-41ea-8871-3516fa7d4d66)


To enable the site:

```
./wordpress.sh enable example.com
```
This command will start the containers for the "example.com" WordPress site

To disable the site:

```
./wordpress.sh disable example.com
```

To delete the site:

```
./wordpress.sh delete example.com
```
