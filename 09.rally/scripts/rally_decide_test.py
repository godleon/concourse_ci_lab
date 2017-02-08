#!/usr/bin/python3

import os, json

cur_path = os.path.dirname(os.path.abspath(__file__))
path_current_test = cur_path + '/current_test.json'
path_current_test_name = cur_path + '/current_test_name'
path_rally_tests = cur_path + '/remain_tests.json'

rally_tests = []
with open(path_rally_tests, 'r') as f:
    rally_tests = json.load(f)

    tmp = rally_tests.popitem()
    cur_test = {tmp[0]: tmp[1]}

    # print(rally_tests[0])

    # with open(remain_tests_path, 'w') as rt:
    #     rt.write()

    with open(path_current_test, 'w') as ct:
        ct.write(json.dumps(cur_test))

    with open(path_current_test_name, 'w') as ctn:
        ctn.write(list(cur_test)[0])

    print(rally_tests)

# print(rally_tests["Authenticate.validate_cinder"])

# for i in range(len(rally_tests)):
#     print(rally_tests[i])



# data = []

# with open(result_path, 'r') as f:
#     data = json.load(f)
#
# print("test result = ", data[0]['sla'][len(data[0]['sla']) - 1]['success'])