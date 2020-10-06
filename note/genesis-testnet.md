# Run local-testnet with single Validator Node

```bash=
STATIC_IP=$(hostname -I)
STATIC_IP=${STATIC_IP% }

mkdir -m700 -p /localnet/{entity,node,genesis}

cd /localnet

cd entity

oasis-node registry entity init --signer.backend file --signer.dir .

cd ../node

oasis-node registry node init \
  --signer.backend file \
  --signer.dir /localnet/entity \
  --node.consensus_address $STATIC_IP:26656 \
  --node.is_self_signed \
  --node.role validator
  
cd ../entity

oasis-node registry entity update \
  --signer.backend file \
  --signer.dir /localnet/entity \
  --entity.node.descriptor /localnet/node/node_genesis.json
  

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
  
  
oasis-node \
  --datadir /localnet/node \
  --genesis.file /localnet/genesis/genesis.json \
  --worker.registration.entity /localnet/entity/entity.json \
  --consensus.validator \
  --debug.dont_blame_oasis \
  --debug.allow_test_keys \
  --log.level debug
```
