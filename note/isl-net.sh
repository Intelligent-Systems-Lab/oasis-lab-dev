
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

WORKDIR=/localnet4/

NODELIST=/nodelist.txt

mkdir -p $WORKDIR

LOCAL_IP=$(hostname -I)
LOCAL_IP=${STATIC_IP% }

run_create_nodes_env(){

    touch $NODELIST

    cd $WORKDIR
    # Setup nodes config file
    for i in {0000..0030}; do 
        node_name="nodes/node$i"
        mkdir -p $node_name; 

        entity_name="entities/entity$i"
        mkdir -p $entity_name;

        oasis-node registry entity init --signer.backend file --signer.dir ./entities/entity$i/

        ENTITY_ID=$(cat ./entities/entity$i/entity.json | jq '.id')
        ENTITY_ID=${ENTITY_ID:1:-1}

        echo "node${i}_pub=$ENTITY_ID" >> $NODELIST
        echo "Generate node $i"
    done

    echo ""
    echo "Init node."

    for i in {0000..0030}; do 
        cd $WORKDIR/nodes/node$i

        oasis-node registry node init \
            --signer.backend file \
            --signer.dir $WORKDIR/entities/entity$i \
            --node.consensus_address $LOCAL_IP:26656 \
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
    
    mkdir -p $WORKDIR/genesis

    cd $WORKDIR/genesis

    oasis-node genesis init \
        --chain.id isltestnet \
        --entity $WORKDIR/entities/entity0000/entity_genesis.json \
        --node $WORKDIR/nodes/node0000/node_genesis.json \
        --registry.debug.allow_unroutable_addresses \
        --debug.dont_blame_oasis \
        --debug.test_entity \
        --debug.allow_test_keys \
        --staking.token_symbol QAQ

    mv $WORKDIR/genesis/genesis.json $WORKDIR/genesis/genesis_t.json
    cat $WORKDIR/genesis/genesis_t.json | jq '.'  >> $WORKDIR/genesis/genesis.json
    rm $WORKDIR/genesis/genesis_t.json

    oasis-node \
        --datadir $WORKDIR/nodes/node0000 \
        --genesis.file $WORKDIR/genesis/genesis.json \
        --worker.registration.entity $WORKDIR/entities/entity0000/entity.json \
        --consensus.validator \
        --log.level debug  >> nodeos.log 2>&1 &

}



run_create_nodes_env
