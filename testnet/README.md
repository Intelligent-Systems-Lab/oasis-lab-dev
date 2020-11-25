# isl-testnet test dev

## What we have done ?

We write two shell scripts and docker environment to launch 10 nodes in your own pc with referencing this, [Run a Validator Node](https://docs.oasis.dev/general/run-a-node/set-up-your-node/run-validator), tutorial.


## How to launch ?

First, setup containers with `docker-compose` file in `oasis-lab-dev/oasis-docker/`

```bash=
cd  oasis-lab-dev/oasis-docker/
docker-compose up

# To terminate these container
# docker-compose down -v

# Next, open 2 terminal by
docker exec -it oasis-docker_oasis-gene_1 bash
```

In terminal 1
```bash=
git clone https://github.com/Intelligent-Systems-Lab/oasis-lab-dev.git

cd oasis-lab-dev/testnet/genesis_preprocess/

bash run.sh
# Press enter to continue, this script will create 30 entities and 30 nodes.
# And registry 30 nodes with each 30 entities. (each entity was registed in one nodes)
# Than, created genesis.json file by merge genesis_example.json, initial with entities and nodes we creates above, with genesis_example.json file.
# After everything set up, script copy pre-config config.yml file to each node's folder and modify some settings in config.yml in each node.
```

In terminal 2
```bash=
# In order to get seed address, we need to launch genesis-node first

cd /oasis-vol/localnet/nodes/node0000

oasis-node --config ./config.yml
# Find seed address here in logs.
```

In terminal 1
```bash=
apt-get -y install iputils-ping sshpass

bash run2.sh
# Press enter to continue
# And paste seed address here
```

## Transfer Tokens

In oasis network, to send a transaction, we can use the command `oasis-node stake account gen_transfer` to sign a transaction with a specific entity (have key-pair in it), and submit this transaction file to the network.

[Transfer Tokens](https://docs.oasis.dev/general/use-your-tokens/transfer-tokens)

```bash=
# Go to `/nodelist.txt` to see nodes public key
# In nodelist.txt, node0000_pub mean node0000's public-key and this node was registed by entity0000

# With public key, we heed to conver it to account address to make a transaction
oasis-node stake pubkey2address --public_key <pub_key>

# Assum we have account node1111 with address oasis11111111111111111111111111111111111111111
# Assum we have account node2222 with address oasis22222222222222222222222222222222222222222

# Get account info (each account have 100 QAQ token, this was set by us in genesis file)
ADDR=/oasis-vol/localnet/nodes/node0000/internal.sock
oasis-node stake account info -a $ADDR --stake.account.address <addr>


# We want to send 10 QAQ from account 1 to account 2
# 10 QAQ (1*10^9)
# And parameter nonce here was set to 0 because this account doesn't make any transaction before.
# And because this transaction must signed by account 1, signer.dir=<path to>/entity1111.
oasis-node stake account gen_transfer \
  "${TX_FLAGS[@]}" \
  --stake.amount 10000000000 \
  --stake.transfer.destination oasis22222222222222222222222222222222222222222 \
  --transaction.file tx_transfer.json \
  --transaction.nonce 0 \
  --transaction.fee.gas 2000 \
  --transaction.fee.amount 2000 \
  --genesis.file  /oasis-vol/localnet/genesis/genesis.json \
  --signer.dir /oasis-vol/localnet/entities/entity1111

# Submit this transaction.
oasis-node consensus submit_tx   -a $ADDR   --transaction.file tx_transfer.json
```

Done.

## Add node 

[Adding or Removing Nodes](https://docs.oasis.dev/general/run-a-node/maintenance-guides/adding-or-removing-nodes)

```bash=
# launch another node in new contrainer
docker run -it -p 8122:22 --name oasis1 tony92151/oasis-docker

```

## Oasis explore

Still working :coffee: :coffee:



