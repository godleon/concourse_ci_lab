import os, json

cur_path = os.path.dirname(os.path.abspath(__file__))
result_path = cur_path + '/rally_result.json'

data = []

with open(result_path, 'r') as f:
    data = json.load(f)

print(data[0]['sla'][len(data[0]['sla']) - 1]['success'])
