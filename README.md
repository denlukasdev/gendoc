# Generate Docker Application

This application generates a Docker environment for Laravel or NodeJS applications.

## Installation

To install project, follow these steps:

1. Fill with relevant variables file `docker_generate.env`
2. Run the `bin/init` command to generate docker
3. Copy `docker_be` folder to laravel application folder and `docker_nodejs` folder to nodeJS application folder
4. Go to the application folder
5. FOR BE: Update Laravel BE application `.env` file according the `docker.env` file:
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

6. Run the `docker_<type>/act start` command to run docker container, where `<type>` is `nodejs` or `be`
7. FOR BE: Run the `docker_be/act be composer install` command to install vendor packages
8. FOR BE: Set database dump to database using command `docker_be/act dump:setup path/to/dump`
9. You will get access to BE by path `<${BASE_BE_URL}:${PORT_NGINX}>` (ex. `localhost:8088`)
10. You will get access to FE by path `localhost:<${PORT_NODE}>` (ex. `localhost:3001`)

## List of Commands

For using commands run `docker_<type>/act <command>` from application root or from another place but built correct  
path to `act` file.
Command list:

- `init` - Create folder with docker environment, according the `docker_generate.env` file
- `dump:setup <path/to/dump>` - Setup dump to docker database
- `dump:create <path/to/folder>` - Create dump of database from docker. If path not provided will create dump in docker folder by default
- `start` - Start docker environment applications
- `rebuild` - Rebuild docker environment
- `stop` - Stop docker environment
- `rmc` - Remove project docker containers
- `status` - Show the list and statuses of project docker containers
- `log` - Show project docker logs
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
	- Configuration files: `path_to/docker-compose.yml` -> Service: `tag_php_fpm` (where `tag` is PROJECT_NAME)

