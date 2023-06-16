# rtCamp-Assignment

The given script is a bash script that can be used to create, enable, disable, and delete WordPress sites using Docker and Docker Compose. Here's a breakdown of the script:

1. The script starts by defining two functions: `check_package` and `install_package`. These functions are used to check if a package is installed and install a package using `apt-get` if it's not already installed.

2. Next, the script checks if Docker and Docker Compose are installed by calling the `check_package` function. If they are not installed, it proceeds to install them using the `install_package` function.

3. After ensuring that Docker and Docker Compose are installed, the script defines the `create_wordpress_site` function. This function creates a WordPress site using Docker Compose. It generates a `docker-compose.yml` file with Nginx, PHP, and MySQL services configured and creates the necessary directories and configuration files.

4. The `enable_disable_site` function is used to enable or disable a WordPress site. It starts or stops the Docker containers associated with the site depending on the provided command.

5. The `delete_site` function deletes a WordPress site by stopping and removing the Docker containers and deleting the associated directories.

6. Finally, the main script validates the command-line arguments and calls the appropriate function based on the provided command (`create`, `enable`, `disable`, or `delete`) and the site name.

To use this script, you can save it to a file (e.g., `wordpress.sh`), make it executable (`chmod +x wordpress.sh`), and then run it with the desired command and site name as arguments. For example:

```
./wordpress.sh create mysite
```

This will create a new WordPress site with the name "mysite".

Please note that this script assumes you have Docker and Docker Compose installed on your system and have appropriate permissions to run Docker commands.
