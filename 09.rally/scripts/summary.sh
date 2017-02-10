#!/bin/bash

SUM_FILE="README.md"
RESOURCE_VER="0.2.50"

echo "" | tee ${SUM_FILE}

CATE_LIST=$(cat finished_tests | cut -d'/' -f6 | uniq)

for cate in ${CATE_LIST}; 
do
    echo "## ${cate}" | tee -a ${SUM_FILE}

    for test in $(cat finished_tests);
    do
        CATE_NAME=$(echo ${test} | cut -d'/' -f6 | uniq)
        TEST_NAME=${test##*/}
        if [ ${CATE_NAME} == ${cate} ]; then
            echo "- [${TEST_NAME}](https://godleon.github.io/osp_test_results/${RESOURCE_VER}/${TEST_NAME%.json}})"
        fi
    done

    echo "" | tee -a ${SUM_FILE}
done