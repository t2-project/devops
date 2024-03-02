# Docker

This directory contains the Docker Compose files to run the entire t2-project in the microservices variant as Docker containers.

```sh
git clone git@github.com:t2-project/devops.git
cd devops/docker

docker-compose up -d
```

This should start up 13 containers.
Make sure that there is enough memory space for that.

The Docker files for the T2-Modulith are located inside its repository: [t2-project/modulith](https://github.com/t2-project/modulith/)
