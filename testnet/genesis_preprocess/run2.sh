#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo
echo "It will set 9 nodes and run it"
read -p "Press [Enter] to continue... or [Control + c] to stop..."

WORKDIR=/oasis-vol/localnet

REPODIR=$(pwd)

NODELIST=/nodelist.txt


run_set_seed(){
    read -p "Enter new public key: "  SEED

    for i in {0001..0009}; do 
        cd $WORKDIR/nodes/node$i

        sed -i "s+\"{{ seed_node_address }}\"+$SEED+" $WORKDIR/nodes/node$i/config.yml
    done
}

run_check_node_alive(){
    for i in {0001..0030}; do
        if [ "`ping -c 1 some_ip_here`" ]        
    done
}


run_node(){
    for i in {0001..0015}; do 
        #cd $WORKDIR/nodes/node$i

        #oasis-node --config ./config.yml >> node.log 2>&1 &
    #done
    sshpass -p 'oasispc' ssh -o StrictHostKeyChecking=no root@172.100.0.${i:2} "cd /oasis-vol/logs && oasis-node --config ./oasis-vol/localnet/nodes/node$i/config.yml >> node$i.log 2>&1 &"
    done
}

run_set_seed

#run_node

echo " --------"
echo "|Done... |"
echo " --------"
