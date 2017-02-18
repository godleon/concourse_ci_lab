#!/usr/bin/python3

import os, json, copy, sys, shutil, math
from os.path import abspath, dirname
from jinja2 import Environment, FileSystemLoader

cur_path = dirname(abspath(__file__))
propagate_tests_path = cur_path + "/propagated_tests"

path_params = ""
path_upstream_list = ""
if len(sys.argv) == 1:
    path_params = dirname(cur_path) + '/configs/test_params.json'
    path_upstream_list = cur_path + '/upstream_tests.list'
elif len(sys.argv) == 2:
    path_params = dirname(cur_path) + "/configs/" + sys.argv[1]
    path_upstream_list = cur_path + '/upstream_tests.list'
else:
    path_params = sys.argv[1]
    path_upstream_list = sys.argv[2]

# 不同服務的 quota 設定
quota_cinder = { "gigabytes": -1, "snapshots": -1, "volumes": -1 }
# quota_neutron = {"floatingip": -1, "health_monitor": -1, "network": -1, "pool": -1, "port": -1, "router": -1, "security_group": -1, "security_group_rule": -1, "subnet": -1, "vip": -1}
quota_neutron = {"floatingip": -1, "network": -1, "port": -1, "router": -1, "security_group": -1, "security_group_rule": -1, "subnet": -1}
quota_nova = {"cores": -1, "fixed_ips": -1, "floating_ips": -1, "injected_file_content_bytes": -1, "injected_file_path_bytes": -1, "injected_files": -1, "instances": -1, "key_pairs": -1, "metadata_items": -1, "ram": -1, "security_group_rules": -1, "security_groups": -1, "server_group_members": -1, "server_groups": -1}


# 使用 rally template & 參數產生對應的測試內容
def generate_test(test_tmpl, paras, concurrency):
    dict_test = copy.deepcopy(test_tmpl[key][0])
    if len(tmpl_test[key]) == 2:
        dict_test = copy.deepcopy(test_tmpl[key][1])

    if "args" in dict_test:
        # 僅測試一次
        if "repetitions" in dict_test["args"]:
            dict_test["args"]["repetitions"] = 1
        # shared storage 必須把 block migration 設定為 false
        if "block_migration" in dict_test["args"]:
            dict_test["args"]["block_migration"] = False
        # 調整測試用的 image 位置
        if "image_location" in dict_test["args"]:
            dict_test["args"]["image_location"] = "http://10.5.91.100:8888/cirros-0.3.5-x86_64-disk.img"
        # 避免太多 security group & rule
        if "security_group_count" in dict_test["args"]:
            dict_test["args"]["security_group_count"] = 1
        if "rules_per_security_group" in dict_test["args"]:
            dict_test["args"]["rules_per_security_group"] = 2


        # For 特定的 cinder scenario
        if "context" in dict_test:
            if "images" in dict_test["context"]:
                if "image_url" in dict_test["context"]["images"]:
                    dict_test["context"]["images"]["image_url"] = "http://10.5.91.100:8888/cirros-0.3.5-x86_64-disk.img"

    if "args" in paras.keys():
        if "flavor" in paras["args"]:
            dict_test["args"]["flavor"]["name"] = paras["args"]["flavor"]
        if "actions" in paras["args"]:
            dict_test["args"]["actions"] = paras["args"]["actions"]
        if "auto_assign_nic" in paras["args"]:
            dict_test["args"]["auto_assign_nic"] = paras["args"]["auto_assign_nic"]
        if "image_location" in paras["args"]:
            dict_test["args"]["image_location"] = paras["args"]["image_location"]
        if "min_sleep" in paras["args"]:
            dict_test["args"]["min_sleep"] = paras["args"]["min_sleep"]
        if "max_sleep" in paras["args"]:
            dict_test["args"]["max_sleep"] = paras["args"]["max_sleep"]

    if "runner" in paras.keys():
        if paras["runner"]["type"] == "rps":
            dict_test["runner"] = {
                "type": paras["runner"]["type"],
                "times": paras["runner"]["time"],
                "rps": concurrency,
                "max_cpu_count": 1
            }
        elif paras["runner"]["type"] == "constant":
            dict_test["runner"] = {
                "type": paras["runner"]["type"],
                "times": paras["runner"]["time"],
                "concurrency": concurrency
            }

    if "sla" in paras:
        dict_test["sla"] = {
            "failure_rate": {"max": paras["sla"]["failure_rate"]},
            "max_avg_duration": paras["sla"]["avg"],
            "max_seconds_per_iteration": paras["sla"]["max"]
        }

    # 設定 service quota 為 unlimited
    if "context" not in dict_test:
        dict_test["context"] = {}
    dict_test["context"]["quotas"] = {"cinder": quota_cinder, "nova": quota_nova, "neutron": quota_neutron}
    # if ("cinder" in key.lower()) or ("volume" in key.lower()):
    #     if "quotas" not in dict_test["context"]:
    #         dict_test["context"]["quotas"] = {}
    #     dict_test["context"]["quotas"]["cinder"] = quota_cinder
    # if "neutron" in key.lower():
    #     if "quotas" not in dict_test["context"]:
    #         dict_test["context"]["quotas"] = {}
    #     dict_test["context"]["quotas"]["neutron"] = quota_neutron
    # if ("nova" in key.lower()) or ("boot" in key.lower()) or ("instance" in key.lower()):
    #     if "quotas" not in dict_test["context"]:
    #         dict_test["context"]["quotas"] = {}
    #     dict_test["context"]["quotas"]["nova"] = quota_nova
    # if key == "NovaSecGroup.boot_and_delete_server_with_secgroups":
    #     if "quotas" not in dict_test["context"]:
    #         dict_test["context"]["quotas"] = {}
    #     dict_test["context"]["quotas"] = {"neutron": quota_neutron}

    # 固定的 user & tenant 配置
    if "users" in dict_test["context"]:
        if "tenants" in dict_test["context"]["users"]:
            dict_test["context"]["users"]["tenants"] = 1
        if "users_per_tenant" in dict_test["context"]["users"]:
            dict_test["context"]["users"]["users_per_tenant"] = 1

    return dict_test


# 讀取 jinja2 template 檔案用的環境變數
# template_context = {
#     "args": { "flavor": { "name": "t1.medium" } }
# }

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
                # tmpl_output = template_env.get_template(file_name).render(template_context)
                tmpl_output = template_env.get_template(file_name).render()
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
                    if item["runner"]["type"] == "rps":
                        cur_concurrency = item["runner"]["min"]
                        while cur_concurrency <= item["runner"]["max"]:
                            real_test = generate_test(tmpl_test, item, round(cur_concurrency, 1))
                            propagated_test[key].append(real_test)
                            cur_concurrency += 0.1
                    elif item["runner"]["type"] == "constant":
                        for i in range(item["runner"]["min"], item["runner"]["max"] + 1):
                            real_test = generate_test(tmpl_test, item, i)
                            propagated_test[key].append(real_test)

                    # 將調整過後的 json 內容寫入檔案
                    with open(path_test_name, 'w') as rt:
                        rt.write(json.dumps(propagated_test))

                    break

    print("========= Propagation Finished =========")



