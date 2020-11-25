#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo
echo "It will create 30 nodes."
read -p "Press [Enter] to continue... or [Control + c] to stop..."

WORKDIR=/localnet

REPODIR=$(pwd)

NODELIST=/nodelist.txt

#########################
mkdir -p $WORKDIR

cd $WORKDIR
mkdir -p $WORKDIR
mkdir -p $WORKDIR/logs

HOST_IP=$(hostname -I)
HOST_IP=${HOST_IP% }

mkdir -m700 -p node
mkdir -m700 -p entity


# entity init
oasis-node registry entity init --signer.backend file --signer.dir $WORKDIR/entity/

ENTITY_ID=$(cat $WORKDIR/entity/entity.json | jq '.id')
ENTITY_ID=${ENTITY_ID:1:-1}

# entity node
cd $WORKDIR/node
oasis-node registry node init \
    --signer.backend file \
    --signer.dir $WORKDIR/entity \
    --node.consensus_address $HOST_IP:26656 \
    --node.is_self_signed \
    --node.role validator

# entity update
cd $WORKDIR/entity
oasis-node registry entity update \
    --signer.backend file \
    --signer.dir $WORKDIR/entity \
    --entity.node.descriptor $WORKDIR/node/node_genesis.json


# init etc
mkdir -m700 -p $WORKDIR/etc
cd $WORKDIR/etc
wget https://github.com/Intelligent-Systems-Lab/oasis-lab-dev/raw/master/testnet/genesis_preprocess/config.yml
# wget https://3bb6584b95a2.ngrok.io/genesis.json

cp /oasis-vol/localnet/genesis/genesis.json $WORKDIR/etc


read -p "Remote endpoint : "  REMOTE_ENDPOINT
sed -i "s+{{ node_dir }}+$WORKDIR/node+" $WORKDIR/etc/config.yml
sed -i "s+{{ genesis.json_dir }}+$WORKDIR/etc/genesis.json+" $WORKDIR/etc/config.yml
sed -i "s+{{ entity.json_dir }}+$WORKDIR/entity/entity.json+" $WORKDIR/etc/config.yml
#sed -i "s+{{ external_address }}:26656+$REMOTE_ENDPOINT+" $WORKDIR/etc/config.yml

echo "RUN NODE!!"
echo "oasis-node --config $WORKDIR/etc/config.yml"

