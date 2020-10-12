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

cd oasis-lab-dev/testnet/genesis_preprocess/

bash run.sh
```

In terminal 2
```bash=
cd /oasis-vol/localnet/nodes/node0000

oasis-node --config ./config.yml

# Find seed address here in logs.
```

In terminal 1
```bash=
apt-get -y install iputils-ping sshpass

bash run2.sh

# paste seed address here
```

```bash=

oasis-node stake pubkey2address --public_key <pub_key>

oasis-node stake account info -a $ADDR --stake.account.address <addr>

oasis-node stake account gen_transfer \
  "${TX_FLAGS[@]}" \
  --stake.amount 10000000000 \
  --stake.transfer.destination oasis1qqv04qjjr0wf8vpd09dxjpn96npne927vg5kaduu \
  --transaction.file tx_transfer.json \
  --transaction.nonce 0 \
  --transaction.fee.gas 2000 \
  --transaction.fee.amount 2000 \
  --genesis.file  /oasis-vol/localnet/genesis/genesis.json \
  --signer.dir /oasis-vol/localnet/entities/entity0000

oasis-node consensus submit_tx   -a $ADDR   --transaction.file tx_transfer.json
```


