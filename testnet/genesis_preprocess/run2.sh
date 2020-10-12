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


red=`tput setaf 1`
green=`tput setaf 2`

run_check_node_alive(){
    touch $WORKDIR/node_deploy_list.txt
    DL=$WORKDIR/node_deploy_list.txt

    LIST=()

    for i in {0001..0030}; do
        if [ "ping -c 1 172.100.0.${i:2}" ]  
        then
            echo "HOST : 172.100.0.${i:2} ... ${green}alive"
            LIST+=(172.100.0.${i:2})
        else
            echo "HOST : 172.100.0.${i:2} ... ${red}offline" 
        fi      
    done
}


run_node(){
    for i in {0001..0015}; do 
        #cd $WORKDIR/nodes/node$i

        #oasis-node --config ./config.yml >> node.log 2>&1 &
    #done
    sshpass -p 'oasispc' ssh -o StrictHostKeyChecking=no root@${LIST[i]} "cd /oasis-vol/logs && oasis-node --config ./oasis-vol/localnet/nodes/node$i/config.yml >> node$i.log 2>&1 &"
    done
}

run_set_seed

#run_node

echo " --------"
echo "|Done... |"
echo " --------"
