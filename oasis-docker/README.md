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

## Docker RUN

```bash=
docker run -it -p 8022:22 --name oasis1 tony92151/oasis-docker
```

## Docker container Remove

```bash=
docker container rm -f oasis1
````
