import json

data = []

with open('rally_result.json', 'r') as f:
    data = json.load(f)

print(data[0]['sla'][len(data[0]['sla']) - 1]['success'])
