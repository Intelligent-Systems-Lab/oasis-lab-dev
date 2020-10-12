# isl-testnet test dev


## test
  
```bash=

cd oasis-lab-dev/oasis-docker

docker-compose up

# open 2 terminal as
docker exec -it oasis-docker_oasis-gene_1 bash

```

In terminal 1
```bash=
git clone https://github.com/Intelligent-Systems-Lab/oasis-lab-dev.git

cd oasis-lab-dev.git/testnet/genesis_preprocess/

bash run.sh
```

In terminal 2
```bash=
cd /oasis-vol/localnet/nodes/node0000

osais-node --config ./config.yml

# Find seed address here in logs.
```

In terminal 1
```bash=
apt-get -y install iputils-ping sshpass

bash run2.sh

# paste seed address here
```


