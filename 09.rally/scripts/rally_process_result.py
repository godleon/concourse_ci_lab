#!/usr/bin/python3

import os, json

cur_path = os.path.dirname(os.path.abspath(__file__))
path_result = cur_path + '/rally_result.json'

with open(path_result, 'r') as f:
    data = json.load(f)
    print("test result = ", data[0]["sla"][len(data[0]["sla"]) - 1]["success"])