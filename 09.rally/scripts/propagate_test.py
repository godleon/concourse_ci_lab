#!/usr/bin/python3

import os, json, copy, sys
from os.path import abspath, dirname
from jinja2 import Environment, FileSystemLoader

cur_path = dirname(abspath(__file__))
print("cur_path = " + cur_path)
propagate_tests_path = dirname(dirname(abspath(__file__))) + "/propagate_tests"
print("propagate_tests_path = " + propagate_tests_path)

path_params = ""
path_upstream_list = ""
if len(sys.argv) == 1:
    path_params = dirname(cur_path) + '/configs/test_params.json'
    path_upstream_list = dirname(cur_path) + '/configs/upstream_tests.list'
else:
    path_params = sys.argv[1]
    path_upstream_list = sys.argv[2]

# 讀取 jinja2 template 檔案用的環境變數
template_context = {
    "flavor_name": "t1.medium"
}
template_env = Environment(autoescape=False, loader=FileSystemLoader(cur_path), trim_blocks=False)

with open(path_params, 'r') as f:
    params = json.load(f)

    for key, item in params.items():
        print(item)

        with open(path_upstream_list, 'r') as ul:
            for path_test in ul:
                path_test = os.getcwd() + "/" + path_test.replace('\n', "")
                print("path_test = " + path_test)
                tmpl_output = template_env.get_template(path_test).render(template_context)
                tmpl_test = json.loads(tmpl_output)

                if list(tmpl_test)[0] == key:
                    propagated_test = {key: []}

                    # test template 的路徑
                    ary_testname = path_test.split('/')
                    test_category_path = propagate_tests_path + "/" + ary_testname[4]
                    path_test_name = test_category_path + "/" + ary_testname[5]

                    # 建立不同 service 的目錄
                    if not os.path.exists(test_category_path):
                        os.makedirs(test_category_path)

                    # 根據參數調整測試檔案
                    for i in range(item["runner"]["min"], item["runner"]["max"] + 1):
                        dict_test = copy.deepcopy(tmpl_test[key][0])

                        if "repetitions" in dict_test["args"].keys():
                            dict_test["args"]["repetitions"] = 1

                        if "runner" in item.keys():
                            if item["runner"]["type"] == "rps":
                                dict_test["runner"] = {
                                    "type": item["runner"]["type"],
                                    "times": item["runner"]["time"],
                                    "rps": i
                                }

                        if "sla" in item.keys():
                            dict_test["sla"] = {
                                "failure_rate": {"max": item["sla"]["failure_rate"]},
                                "max_avg_duration": item["sla"]["avg"],
                                "max_seconds_per_iteration": item["sla"]["max"]
                            }

                        propagated_test[key].append(dict_test)

                    # 將調整過後的 json 內容寫入檔案
                    with open(path_test_name, 'w') as rt:
                        rt.write(json.dumps(propagated_test))

                    break

    print("========= Propagation Finished =========")



