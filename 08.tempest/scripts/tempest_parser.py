#!/bin/python3

from jinja2 import Environment, FileSystemLoader
from collections import OrderedDict
import os, re


# 取得完整的 test name
def get_full_test_name(line_data):
    return line_data.split('}')[1].split('[')[0].strip()
    # if "setUpClass" not in line_data:
    #     return line_data.split(' ')[1]
    # else:
    #     return line_data.split('(')[1].split(')')[0]


# 取得花費時間
def get_time_spend(line_data):
    return line_data.split('[')[1].split(']')[0]


cur_path = os.path.dirname(os.path.abspath(__file__))
template_env = Environment(autoescape=False, loader=FileSystemLoader(cur_path), trim_blocks=False)

log_path = cur_path + '/ra-out.txt'
log_file = open(log_path, 'r')
output_file = "tempest_output.html"

# classified test variables
func_passed_tests = {}
func_skipped_tests = {}
func_failed_tests = {}
scen_passed_tests = {}
scen_skipped_tests = {}
scen_failed_tests = {}

# queue variables for 3 lines
buf_curline = ["", "", ""]
buf_traceback = []
buf_summary = []

# pattern for find api name & result
pat = re.compile('^{\d+}.*\.\.\..*$')
pat_scenario = re.compile('^{\d+}\s{1}tempest.scenario.*\.\.\..*$')
pat_passed = re.compile('^.*\.\.\.\s{1}ok$')
pat_failed = re.compile('^.*\.\.\.\s{1}FAILED$')
pat_skipped = re.compile('^.*\.\.\.\s{1}SKIPPED\:.*$')

idx = 1
cur_failed_api_name = ""
for line in log_file:
    buf_curline[2] = buf_curline[1]
    buf_curline[1] = buf_curline[0]
    buf_curline[0] = line

    if pat_passed.match(line):
        if "scenario." in line:
            scen_passed_tests[get_full_test_name(line)] = get_time_spend(line)
        else:
            func_passed_tests[get_full_test_name(line)] = get_time_spend(line)
    elif pat_failed.match(line):
        if "scenario." in line:
            scen_failed_tests[get_full_test_name(line)] = []
        else:
            func_failed_tests[get_full_test_name(line)] = []
    elif pat_skipped.match(line):
        if "scenario." in line:
            scen_skipped_tests[get_full_test_name(line)] = line.split("SKIPPED:")[1].strip()
        else:
            func_skipped_tests[get_full_test_name(line)] = line.split("SKIPPED:")[1].strip()

    # 開始記錄 summary 訊息
    if len(buf_summary) > 0:
        buf_summary.append(line.replace('\n', ""))
    if line.strip() == "Totals":
        buf_summary.append("======")
        buf_summary.append(line.replace('\n', ""))

    # 開始記錄 API call 錯誤訊息
    if len(cur_failed_api_name) > 0 and len(line.strip()) > 0:
        if "scenario." in cur_failed_api_name:
            scen_failed_tests[cur_failed_api_name].append(line)
        else:
            func_failed_tests[cur_failed_api_name].append(line)

    # 遇到錯誤輸出訊息
    if '---------------------------------------------------' in buf_curline[0]:
        cur_failed_api_name = buf_curline[1].strip().split('[')[0]
        # if "setUpClass" in buf_curline[1]:
        #     cur_failed_api_name = buf_curline[1].split('(')[1].split(')')[0]
        # else:
        #     cur_failed_api_name = buf_curline[1].split('[')[0]

    if "Captured" not in line and len(cur_failed_api_name) > 0 and buf_curline[1].replace('\n', "").strip() == buf_curline[2].replace('\n', "").strip() == "":
        if "scenario." in cur_failed_api_name:
            del scen_failed_tests[cur_failed_api_name][-1]
        else:
            del func_failed_tests[cur_failed_api_name][-1]
        cur_failed_api_name = ""

log_file.close()

template_context = {
    'buf_summary': buf_summary,
    'func_passed_tests': OrderedDict(sorted(func_passed_tests.items(), key=lambda t: t[0])),
    'func_skipped_tests': OrderedDict(sorted(func_skipped_tests.items(), key=lambda t: t[0])),
    'func_failed_tests': OrderedDict(sorted(func_failed_tests.items(), key=lambda t: t[0])),
    'scen_passed_tests': OrderedDict(sorted(scen_passed_tests.items(), key=lambda t: t[0])),
    'scen_skipped_tests': OrderedDict(sorted(scen_skipped_tests.items(), key=lambda t: t[0])),
    'scen_failed_tests': OrderedDict(sorted(scen_failed_tests.items(), key=lambda t: t[0])),
}

with open(output_file, 'w') as f:
    html = template_env.get_template("template.html").render(template_context)
    f.write(html)

print("Parse Tempest log finished!")

