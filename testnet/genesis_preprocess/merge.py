import json
import os, sys
import argparse

import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--genesis_path', type=str, default=None)
parser.add_argument('--example_path', type=str, default=None)

args = parser.parse_args()

genesis_path = os.path.expanduser(args.genesis_path)
example_path = os.path.expanduser(args.example_path)

#print("Merge file :",genesis_path, " to ",example_path)

if genesis_path==example_path or genesis_path==None or example_path==None:
    sys.exit("File error.")

################
leger_example= '{"oasis1": {"escrow": {"active": {"balance": "500000000000","total_shares": "5000000000000000"},"commission_schedule": {"bounds": [{"rate_max": "20000","rate_min": "0"}],"rates": [{"rate": "5000"}]},"debonding": {"balance": "0","total_shares": "0"},"stake_accumulator": {}},"general": {"balance": "2500000000000"}}}'

delegations_exp = '{"oasis1": {"oasis2": {"shares": "4000000000000000"},"oasis3": {"shares": "1000000000000000"}}}'
################


# print("Merge file :",genesis_path, " to ",example_path)

#print(json.dumps(leger_example, sort_keys=True, indent=4, separators=(',', ': ')))

### Load teo file ###

with open(genesis_path) as json_file:
    json_gene = json.load(json_file)

with open(example_path) as json_file:
    json_exp = json.load(json_file)
#####################

json_gene_entity = json_gene['registry']['entities']
json_gene_entity_len = len(json_gene_entity)

json_gene_nodes = json_gene['registry']['nodes']
json_gene_nodes_len = len(json_gene_entity)

json_gene_total = 10000000000000000000

# Add entities to exp file
json_exp['registry']['entities'] = json_gene_entity
# Add node to exp file
json_exp['registry']['nodes'] = json_gene_nodes

# Add delegations to exp file
entities_account_list = []
for i in json_gene_entity:
    k = i['signature']['public_key']

    proc = subprocess.Popen('oasis-node stake pubkey2address  --public_key '+k , shell=True,stdout=subprocess.PIPE)
    outs, errs = proc.communicate(timeout=3)

    entities_account_list.append(outs.decode('utf-8').splitlines()[0])

nodes_account_list = []
for i in json_gene_nodes:
    k = i['signatures'][0]['public_key']

    proc = subprocess.Popen('oasis-node stake pubkey2address  --public_key '+k , shell=True,stdout=subprocess.PIPE)
    outs, errs = proc.communicate(timeout=3)

    nodes_account_list.append(outs.decode('utf-8').splitlines()[0])

# print(entities_account_list)
# print(nodes_account_list)

delegations_str = ''
for i in range(len(entities_account_list)):
    delegations_str = delegations_str + delegations_exp.replace('oasis1', entities_account_list[i]).replace('oasis2', entities_account_list[i]).replace('oasis3', nodes_account_list[i]) +','
    #json_exp['staking']['delegations'][entities_account_list[i]][entities_account_list[i]]['shares'] = "4000000000000000"
    #json_exp['staking']['delegations'][entities_account_list[i]][nodes_account_list[i]]['shares'] = 1000000000000000
delegations_str = '['+delegations_str[:-1]+']'

for i in json.loads(delegations_str):
    json_exp['staking']['delegations'].update(i)


# Add ledger to exp file
leger_str = ''
for i in range(len(entities_account_list)):
    leger_str = leger_str + leger_example.replace('oasis1', entities_account_list[i]) + ','
leger_str = '['+leger_str[:-1]+']'

for i in json.loads(leger_str):
    json_exp['staking']['ledger'].update(i)


# Each ledger have 300000000000 token
# staking.common_pool = staking.total_supply - len(ledger)*300000000000

#print(json_gene_total)

json_common_pool = json_gene_total - len(json.loads(leger_str))*3000000000000

json_exp['staking']['common_pool'] = str(json_common_pool)
 
with open(example_path.replace('_example', '_result'), 'w') as outfile:
    json.dump(json_exp, outfile)
