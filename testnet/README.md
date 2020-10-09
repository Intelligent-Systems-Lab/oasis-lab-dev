# isl-testnet test dev


## test
  
```bash=
STATIC_IP=140.113.***.***

WORKDIR=/localnet/

mkdir -m700 -p /localnet/{entity0,entity1,entity2,node0,node1,node2,node3,node4,genesis}

cd $WORKDIR/localnet

cd $WORKDIR/entity0

oasis-node registry entity init --signer.backend file --signer.dir .

cd $WORKDIR/entity1

oasis-node registry entity init --signer.backend file --signer.dir .

cd $WORKDIR/entity2

oasis-node registry entity init --signer.backend file --signer.dir .


########################################################
########################################################

cd $WORKDIR/node0

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity0 \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator

cd $WORKDIR/node1

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity1 \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator
  
cd $WORKDIR/node2

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity1 \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator
  
cd $WORKDIR/node3

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity2 \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator
  
cd $WORKDIR/node4

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity2 \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator
  
  
########################################################
########################################################

cd $WORKDIR/entity0

oasis-node registry entity update \
  --signer.backend file \
  --signer.dir /localnet/entity0 \
  --entity.node.descriptor /localnet/node0/node_genesis.json

cd $WORKDIR/entity1

oasis-node registry entity update \
  --signer.backend file \
  --signer.dir /localnet/entity1 \
  --entity.node.descriptor /localnet/node1/node_genesis.json \
  --entity.node.descriptor /localnet/node2/node_genesis.json
  
cd $WORKDIR/entity2

oasis-node registry entity update \
  --signer.backend file \
  --signer.dir /localnet/entity2 \
  --entity.node.descriptor /localnet/node3/node_genesis.json \
  --entity.node.descriptor /localnet/node4/node_genesis.json
  
########################################################
########################################################

cd $WORKDIR/genesis

oasis-node genesis init \
  --chain.id isltestnet \
  --entity /localnet/entity0/entity_genesis.json \
  --entity /localnet/entity1/entity_genesis.json \
  --entity /localnet/entity2/entity_genesis.json \
  --node /localnet/node0/node_genesis.json \
  --node /localnet/node1/node_genesis.json \
  --node /localnet/node2/node_genesis.json \
  --node /localnet/node3/node_genesis.json \
  --node /localnet/node4/node_genesis.json \
  --staking.token_symbol QAQ
  
```

Before launch genesis-node, it still needs to config genesis-file manually. :cry: 

Or download the `localnet.zip` and unzip to `/` to begin to launch genesis-node

```bash=
oasis-node \
  --datadir /localnet/node0 \
  --genesis.file /localnet/genesis/genesis.json \
  --worker.registration.entity /localnet/entity0/entity.json \
  --consensus.validator \
  --log.level debug
```

