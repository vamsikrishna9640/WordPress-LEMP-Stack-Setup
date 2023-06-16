# rtCamp-Assignment
# WordPress LEMP Stack Setup

This script automates the setup of a LEMP (Linux, Nginx, MySQL, PHP) stack for hosting WordPress websites using Docker and Docker Compose. It creates a basic WordPress site with Nginx as the web server, MySQL as the database server, and PHP-FPM for PHP processing. It also includes phpMyAdmin for managing the MySQL database.

## Prerequisites

- Linux-based operating system (tested on Ubuntu)


## Installation

1. Clone the repository to your local machine:

   ```bash
  t
   ```

2. Change into the project directory:

   ```bash
   cd wordpress-lemp-stack
   ```

3. Make the script executable:

   ```bash
   chmod +x script.sh
   ```

## Usage

Run the script with the following command:

```bash
./script.sh [command] [site_name]
```

Replace `[command]` with one of the following options:

- `create`: Creates a new WordPress site with the specified `[site_name]`.
- `enable`: Enables a previously created WordPress site with the specified `[site_name]`.
- `disable`: Disables a previously created WordPress site with the specified `[site_name]`.
- `delete`: Deletes a previously created WordPress site with the specified `[site_name]`.

Replace `[site_name]` with the desired name for your WordPress site.

### Example Usage

1. Create a new WordPress site:

   ```bash
   ./script.sh create mysite
   ```

   This command will create a new directory named `mysite` and set up the LEMP stack for hosting the WordPress site.

2. Enable an existing WordPress site:

   ```bash
   ./script.sh enable mysite
   ```

   This command will start the containers for the `mysite` WordPress site.

3. Disable an existing WordPress site:

   ```bash
   ./script.sh disable mysite
   ```

   This command will stop the containers for the `mysite` WordPress site.

4. Delete an existing WordPress site:

   ```bash
   ./script.sh delete mysite
   ```

   This command will stop and remove the containers for the `mysite` WordPress site, delete the site directory, and remove the `/etc/hosts` entry.

## Important Note

- The script assumes that you have root privileges and will prompt for your sudo password when necessary for installation and configuration tasks.
- Make sure to review the script and modify it according to your requirements before running it.
- The script is provided as-is and may require adjustments based on your specific environment and preferences.


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
