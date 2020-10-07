# Run local-testnet with single Validator Node


## RUN 

[official document](https://docs.oasis.dev/oasis-core/development-setup/running-tests-and-development-networks/single-validator-node-network)  

### Steps 

`Create folders structure` > `Init & register entity` > `Init node` > `Update entity` > `Init genesis` > `Launch genesis node`

```bash=
# Get local ip (127.0.0.2  in docker) 
LOCAL_IP=$(hostname -I)
LOCAL_IP=${STATIC_IP% }

```
Create folders structure
```bash=  
mkdir -m700 -p /localnet/{entity,node,genesis}

cd /localnet

```

Init & register entity
```bash=   
cd entity

oasis-node registry entity init --signer.backend file --signer.dir .
```

Init node
```bash=   
cd ../node

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity \
  --node.consensus_address $LOCAL_IP:26656 \
  --node.is_self_signed \
  --node.role validator
```
Update entity
```bash=  
cd ../entity

oasis-node registry entity update \
  --signer.backend file \
  --signer.dir /localnet/entity \
  --entity.node.descriptor /localnet/node/node_genesis.json
```

Init genesis
```bash=
cd ../genesis

oasis-node genesis init \
  --chain.id isltestnet \
  --entity /localnet/entity/entity_genesis.json \
  --node /localnet/node/node_genesis.json \
  --debug.dont_blame_oasis \
  --debug.test_entity \
  --debug.allow_test_keys \
  --registry.debug.allow_unroutable_addresses \
  --staking.token_symbol QAQ
  
```

Launch genesis node
```bash=
oasis-node \
  --datadir /localnet/node \
  --genesis.file /localnet/genesis/genesis.json \
  --worker.registration.entity /localnet/entity/entity.json \
  --consensus.validator \
  --debug.dont_blame_oasis \
  --debug.allow_test_keys \
  --log.level debug
```

## Next

Goal auto generate local-test with nodes as validators.
 
1. auto delegate for some nodes
2. chain explorer 
