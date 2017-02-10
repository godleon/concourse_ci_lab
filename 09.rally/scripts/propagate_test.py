#!/usr/bin/python3

import os, json, copy, sys, shutil
from os.path import abspath, dirname
from jinja2 import Environment, FileSystemLoader

cur_path = dirname(abspath(__file__))
propagate_tests_path = cur_path + "/propagated_tests"

path_params = ""
path_upstream_list = ""
if len(sys.argv) == 1:
    path_params = dirname(cur_path) + '/configs/test_params.json'
    path_upstream_list = cur_path + '/upstream_tests.list'
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
                path_test = path_test.replace("\n", "")

                file_name = path_test[path_test.rindex("/")+1:]
                tmp_filename = os.getcwd() + "/" + file_name
                shutil.copyfile(path_test, tmp_filename)
                tmpl_output = template_env.get_template(file_name).render(template_context)
                tmpl_test = json.loads(tmpl_output)
                os.remove(tmp_filename)

                if list(tmpl_test)[0] == key:
                    propagated_test = {key: []}

                    # test template 的路徑
                    str = path_test
                    test_category_path = propagate_tests_path + "/" + str[:str.rindex("/")][str[:str.rindex("/")].rindex("/")+1:]
                    path_test_name = test_category_path + "/" + file_name

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



