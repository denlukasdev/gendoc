# Generated NodeJS Docker

## Notes
1. In generated docker internal and external ports could be changed in `.env` file. After update restart the container.
2. In generated docker Node version could be changed in `docker_nodejs/images/nodejs/Dockerfile` file:  
`FROM node:<node_version>-alpine`  
where `<node_version>` nodeJS version. Rebuild container after node version update.


## List of Commands

For using commands run `docker_nodejs/act/act <command>` from application root or from another place but built correct  
path to `act` file.
Command list:

- `start` - Start docker environment applications
- `rebuild` - Rebuild docker environment
- `stop` - Stop docker environment
- `rmc` - Remove project docker containers
- `status` - Show the list and statuses of project docker containers
- `fe <optional command>` - Go into container with application front-end if <optional command> is empty or execute <optional command> inside container from outside
