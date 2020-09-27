# Docker

## Build form docker file

```bash=
./build.sh doc2

# push
docker login && docker push tony92151/oasis-docker
```

## Pull from docker hub

```bash=
docker pull tony92151/oasis-docker:latest
```
[hub](https://hub.docker.com/r/tony92151/oasis-docker)
## Docker RUN

```bash=
docker run -it -p 8022:22 -p 26656:26656 --name oasis1 tony92151/oasis-docker
```

## Docker container Remove

```bash=
docker container rm -f oasis1
````
