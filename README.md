# Laravel-React Dockerized Application

This application generates a Docker environment for Laravel+React applications.

## Installation

To install project, follow these steps:

1. Copy the `docker.env.sample` file with name `docker.env` and fill with actual variables
2. Run the `bin/doc init` command to generate docker folder 
3. Copy the FE and BE applications to `./apps` folder
4. Update Laravel BE aplication `.env` file according the `docker.env` file:
	</br>
   `APP_URL=http://${BASE_BE_URL}:${PORT_NGINX}`
   </br>
   `FE_URL=http://localhost:${PORT_NODE}`
   </br>
   `DB_HOST=${PROJECT_NAME}_mysql`
   </br>
   `DB_DATABASE=${DB_DATABASE}`
   </br>
   `DB_USERNAME=${DB_USER}`
   </br>
   `DB_PASSWORD=${DB_PASSWORD}`
   </br>
	
5. Run the `bin/doc start` command to run docker containers
6. Run the `bin/doc be composer install` command to install vendor packages
7. Set database dump to database using command `bin/doc dump-setup path/to/dump`
8. You will get access to BE by path `<${BASE_BE_URL}:${PORT_NGINX}>` (ex. `localhost:8088`)
9. You will get access to FE by path `localhost:<${PORT_NODE}>` (ex. `localhost:3001`)

## List of Commands

For using commands run `bin/doc <command>` from this application root or from another place but built correct  
path to bin/doc file.
Here are command list for working with this application:

- `init` - Create folder with docker environment, according the `docker.env` file, replace if it is already exist
- `dump-setup <path/to/dump>` - Setup dump to docker database
- `dump-create <path/to/folder>` - Create dump of database from docker in the folder is set in command 
- `start` - Start docker environment applications
- `rebuild` - Rebuild docker environment
- `stop` - Stop docker environment
- `rmc` - Remove project docker containers
- `status` - Show the list and statuses of project docker containers
- `fe <optional command>` - Go into container with application front-end if <optional command> is empty or execute <optional command> inside container from outside
- `be <optional command>` - Go into container with application back-end if <optional command> is empty or execute <optional command> inside container from outside
- `db` - Go into application database to mysql 

## Configuring Xdebug on PhpStorm

To configure Xdebug on PhpStorm, follow these steps:

1. Open PhpStorm Settings->PHP->Servers press '`+`' to create new server with settings:
	- Name: Docker
	- Host: Docker
	- Port: 80
	- Debugger: Xdebug
	- Use path mappings: press the 'checkbox', compare BE application directory folder and application in docker directory (`/var/www/app`)

2. Open PhpStorm Settings->PHP->CLI Interpreter->... :
	- \+ -> From Docker -> Docker Compose -> Server: Docker ->
	- Configuration files: `path_to_docker-compose.yml` -> Service: `tag_php_fpm` (where `tag` is PROJECT_NAME)

