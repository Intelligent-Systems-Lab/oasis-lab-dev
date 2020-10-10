import json
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--genesis_path', type=str, default=None)
parser.add_argument('--example_path', type=str, default=None)

parser.add_argument('-f')

args = parser.parse_args()

genesis_path = os.path.expanduser(args.genesis_path)
example_path = os.path.expanduser(args.example_path)