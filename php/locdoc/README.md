# Generated BE Docker

## Notes
1. In generated docker ports and database variables could be changed in `.env` file. After update restart the container.
2. Created database will be store in `docker_be` folder as `db_volumes` 
3. Inside the container created aliases:  
	`a` - php artisan;  `acc` - clear all cache data for laravel;

## List of Commands

For using commands run `docker_be/act <command>` from this application root or from another place but built correct  
path to `act` file.
Command list for working with this application:

- `dump:setup <path/to/dump>` - Setup dump to docker database
- `dump:create <path/to/folder>` - Create dump of database from docker in the folder is set in command 
- `start` - Start docker environment applications
- `rebuild` - Rebuild docker environment
- `stop` - Stop docker environment
- `rmc` - Remove project docker containers
- `status` - Show the list and statuses of project docker containers
- `log` - Show project docker logs
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
	- Configuration files: `path_to_/docker-compose.yml` -> Service: `tag_php_fpm` (where `tag` is PROJECT_TAG)

