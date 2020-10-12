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
reset=`tput sgr0`

run_check_node_alive(){

    touch $WORKDIR/node_deploy_list.txt
    DL=$WORKDIR/node_deploy_list.txt

    LIST=()

    for i in {2..30}; do
        if ping -c 1 -W 1 172.100.0.$i >> /tmp/ptmp.tmp
        then
            echo "HOST : 172.100.0.$i ... ${green}alive${reset}"
            LIST+=($i)
        else
            echo "HOST : 172.100.0.$i ... ${red}offline${reset}" 
        fi      
    done
    #echo ${LIST[@]}
}


run_node(){
    echo "After checking nodes. It's time to launch all nodes."
    read -p "Press [Enter] to continue... or [Control + c] to stop..."

    for i in {1..10}; do 

    v=$(printf "%04d" $i)
    #echo $v
    sleep 0.1
    sshpass -p 'oasispc' ssh -o StrictHostKeyChecking=no root@172.100.0.${LIST[i]} "oasis-node --config /oasis-vol/localnet/nodes/node$v/config.yml >> /oasis-vol/localnet/logs/node$v.log 2>&1 &"
    echo "DEPLOY ${green} node$v ${reset} to ${green}172.100.0.${LIST[i]} ${reset}"
    #v=10#$i
    # v=${LIST[i]}
    #echo "172.100.0.${LIST[i]}"
    #echo "172.100.0.$((10#${LIST[i]}))"
    #sshpass -p 'oasispc' ssh -o StrictHostKeyChecking=no root@172.100.0.${LIST[i]} "hostname -I"
    done
}

run_set_seed

run_check_node_alive
run_node

echo " --------"
echo "|Done... |"
echo " --------"
