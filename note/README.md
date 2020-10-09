# Outline

[Part 0 : Overview](note/00_overview.md)

[Part 1 : Run a Validator Node](note/01_validator.md)

[Part 2 : Deploying a RunTime](note/02_runtime.md)

[Part 3 : Run a local testnet](note/03_local-testnet.md)



# Part 1 : Run a Validator Node

https://docs.oasis.dev/general/run-a-node/set-up-your-node/running-a-node

## Install some tools

```bash=
apt install -y jq nano 
```

`We set up two parts in one docker container, so the STATIC_IP parameter should be the it's own ip address. If not, STATIC_IP parameter should be remote machine's ip address.`

## Set up a localhost runtime eng

```bash=
mkdir -m700 -p localhostdir/{entity,node}
cd /localhostdir

wget https://github.com/oasisprotocol/mainnet-artifacts/releases/download/2020-09-22/genesis.json

GENESIS_FILE_PATH=/localhostdir/genesis.json

cd entity

oasis-node registry entity init

ENTITY_ID=$(cat entity.json | jq '.id')

#cat entity.json | jq '.id' | export ENTITY_ID=

ENTITY_ID=${ENTITY_ID:1:-1}

STATIC_IP=$(hostname -I)
STATIC_IP=${STATIC_IP% }

echo "ENTITY_ID = $ENTITY_ID"
echo "STATIC_IP = $STATIC_IP"

cd ../node

oasis-node registry node init \
  --node.entity_id $ENTITY_ID \
  --node.consensus_address $STATIC_IP:26656 \
  --node.role validator
  
cd ../entity
oasis-node registry entity update \
  --entity.node.descriptor /localhostdir/node/node_genesis.json
```

## Set up a remote consensus eng

```bash=
STATIC_IP=$(hostname -I)
STATIC_IP=${STATIC_IP% }

echo "STATIC_IP = $STATIC_IP"

mkdir -m700 -p /serverdir/{etc,node,node/entity}
cd /serverdir

cp /localhostdir/node/*.pem /serverdir/node/

chmod -R 600 /serverdir/node/*.pem

cp /localhostdir/entity/entity.json /serverdir/node/entity/

cp $GENESIS_FILE_PATH /serverdir/etc/

cd /serverdir/etc/

wget https://gist.github.com/tony92151/3cd804235481c718d4c33b775dbf239b/raw/4905266215e66d63b33a31764891fedb1d0576d3/config.yml

sed -i "s/{{ seed_node_address }}/E27F6B7A350B4CC2B48A6CBE94B0A02B0DCB0BF3@35.199.49.168:26656/" /serverdir/etc/config.yml

sed -i "s/{{ external_address }}/$STATIC_IP/" /serverdir/etc/config.yml

chmod -R go-r,go-w,go-x /serverdir

echo "RUN NODE"
oasis-node --config /serverdir/etc/config.yml

```
