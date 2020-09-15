# Docker Environments

## Setup 
Note that docker only supports GPU access for Linux distributions
1. Install Docker
   https://docs.docker.com/engine/install/
2. Install Docker Compose 
   https://docs.docker.com/compose/install/

## General Notes

### Useful Docker Compose Commands

Launch docker-compose 
```
docker-compose up -d
```

Get the status of docker-compose services
```
docker-compose ps
```

Enter the shell of a docker-compose service
```
docker-compose exec <service-name> bash
```

