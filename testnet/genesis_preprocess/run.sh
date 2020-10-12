3
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

WORKDIR=/oasis-vol/localnet

REPODIR=$(pwd)

NODELIST=/nodelist.txt

mkdir -p $WORKDIR
mkdir -p $WORKDIR/logs

HOST_IP=$(hostname -I)
HOST_IP=${HOST_IP% }

run_create_nodes_env(){

    touch $NODELIST

    cd $WORKDIR
    # Setup nodes config file
    for i in {0000..0030}; do 
        node_name="nodes/node$i"
        mkdir -m700 -p $node_name; 

        entity_name="entities/entity$i"
        mkdir -m700 -p $entity_name;

        oasis-node registry entity init --signer.backend file --signer.dir $WORKDIR/entities/entity$i/

        ENTITY_ID=$(cat $WORKDIR/entities/entity$i/entity.json | jq '.id')
        ENTITY_ID=${ENTITY_ID:1:-1}

        echo "node${i}_pub=$ENTITY_ID" >> $NODELIST
        echo "Generate entity $i"
    done

    echo ""
    echo "Init node."

    for i in {0000..0030}; do 
        cd $WORKDIR/nodes/node$i

        oasis-node registry node init \
            --signer.backend file \
            --signer.dir $WORKDIR/entities/entity$i \
            --node.consensus_address $LOCAL_IP:26656 \
            --node.is_self_signed \
            --node.role validator
    done

    echo ""
    echo "Update entity."

    for i in {0000..0030}; do 
        cd $WORKDIR/entities/entity$i

        oasis-node registry entity update \
            --signer.backend file \
            --signer.dir $WORKDIR/entities/entity$i \
            --entity.node.descriptor $WORKDIR/nodes/node$i/node_genesis.json
    done

    cd $WORKDIR 
}

run_setup_genesis_env(){
    
    mkdir -m700 -p $WORKDIR/genesis

    cd $WORKDIR/genesis

    # oasis-node genesis init \
    #     --chain.id isltestnet \
    #     --entity $WORKDIR/entities/entity0000/entity_genesis.json \
    #     --entity $WORKDIR/entities/entity0001/entity_genesis.json \
    #     --entity $WORKDIR/entities/entity0002/entity_genesis.json \
    #     --node $WORKDIR/nodes/node0000/node_genesis.json \
    #     --node $WORKDIR/nodes/node0001/node_genesis.json \
    #     --node $WORKDIR/nodes/node0002/node_genesis.json \
    #     --staking.token_symbol QAQ

    oasis-node genesis init \
        --chain.id isltestnet \
        --entity $WORKDIR/entities/entity0000/entity_genesis.json \
        --entity $WORKDIR/entities/entity0001/entity_genesis.json \
        --entity $WORKDIR/entities/entity0002/entity_genesis.json \
        --entity $WORKDIR/entities/entity0003/entity_genesis.json \
        --entity $WORKDIR/entities/entity0004/entity_genesis.json \
        --entity $WORKDIR/entities/entity0005/entity_genesis.json \
        --entity $WORKDIR/entities/entity0006/entity_genesis.json \
        --entity $WORKDIR/entities/entity0007/entity_genesis.json \
        --entity $WORKDIR/entities/entity0008/entity_genesis.json \
        --entity $WORKDIR/entities/entity0009/entity_genesis.json \
        --node $WORKDIR/nodes/node0000/node_genesis.json \
        --node $WORKDIR/nodes/node0001/node_genesis.json \
        --node $WORKDIR/nodes/node0002/node_genesis.json \
        --node $WORKDIR/nodes/node0003/node_genesis.json \
        --node $WORKDIR/nodes/node0004/node_genesis.json \
        --node $WORKDIR/nodes/node0005/node_genesis.json \
        --node $WORKDIR/nodes/node0006/node_genesis.json \
        --node $WORKDIR/nodes/node0007/node_genesis.json \
        --node $WORKDIR/nodes/node0008/node_genesis.json \
        --node $WORKDIR/nodes/node0009/node_genesis.json \
        --staking.token_symbol QAQ

    # rejq is a tool to reformat json file. (see /rejq.sh)
    #rejq $WORKDIR/genesis/genesis.json

    cp $REPODIR/genesis_example.json $WORKDIR/genesis/

    python3 $REPODIR/merge.py --genesis_path $WORKDIR/genesis/genesis.json  --example_path $WORKDIR/genesis/genesis_example.json

    #bash /./rejq.sh $WORKDIR/genesis/genesis.json
    rm genesis.json genesis_example.json
    mv genesis_result.json genesis.json

    #rm genesis_result.json

    bash /./rejq.sh $WORKDIR/genesis/genesis.json

    sed -i "s/18446744073709552000/18446744073709551615/" $WORKDIR/genesis/genesis.json

    #wget https://gist.github.com/tony92151/3cd804235481c718d4c33b775dbf239b/raw/4905266215e66d63b33a31764891fedb1d0576d3/config.yml

    #oasis-node --config ./config.yml
    
    # oasis-node \
    #     --datadir $WORKDIR/nodes/node0000 \
    #     --genesis.file $WORKDIR/genesis/genesis.json \
    #     --worker.registration.entity $WORKDIR/entities/entity0000/entity.json \
    #     --consensus.validator \
    #     --debug.dont_blame_oasis \
    #     --debug.allow_test_keys \
    #     --log.level debug  

    #>> genesis.log 2>&1 &
}

# Set up config.yml

run_setup_config(){
    for i in {0000..0030}; do 
        cp $REPODIR/config.yml $WORKDIR/nodes/node$i/

        sed -i "s+format: JSON+format: logfmt+" $WORKDIR/nodes/node$i/config.yml

        sed -i "s+{{ node_dir }}+$WORKDIR/nodes/node$i+" $WORKDIR/nodes/node$i/config.yml
        sed -i "s+{{ genesis.json_dir }}+$WORKDIR/genesis/genesis.json+" $WORKDIR/nodes/node$i/config.yml
        sed -i "s+{{ entity.json_dir }}+$WORKDIR/entities/entity$i/entity.json+" $WORKDIR/nodes/node$i/config.yml

        sed -i "s+localhost:26656+$HOST_IP:26656+" $WORKDIR/nodes/node$i/config.yml
        sed -i "s+{{ external_address }}:26656+$HOST_IP:26656+" $WORKDIR/nodes/node$i/config.yml
    done

    sed -i "s+- \"{{ seed_node_address }}\"+#- \"{{ seed_node_address }}\"+" $WORKDIR/nodes/node0000/config.yml
    
}



run_create_nodes_env

run_setup_genesis_env

run_setup_config
