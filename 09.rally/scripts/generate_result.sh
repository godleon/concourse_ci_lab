#!/bin/bash

RESOURCE_VER=$(cat git_semver/version)
CURRENT_TEST=$(cat rally_test/current_test)
FINISHED_TESTS="$(pwd)/rally_test/finished_tests"

whoami
env

apt-get update >/dev/null
apt-get -y install git >/dev/null

git clone rally_result rally_summary
cd rally_summary
mkdir -p ${RESOURCE_VER}


SUM_FILE="${RESOURCE_VER}/README.md"
echo "" | tee ${SUM_FILE}

CATE_LIST=$(cat ${FINISHED_TESTS} | cut -d'/' -f6 | uniq)
for cate in ${CATE_LIST}; 
do
    echo "## ${cate}" | tee -a ${SUM_FILE}

    for test in $(cat ${FINISHED_TESTS});
    do
        TMP=${test%/*}
        # CATE_NAME=$(echo ${test} | cut -d'/' -f6 | uniq)
        CATE_NAME=${TMP##*/}
        TEST_NAME=${test##*/}
        if [ ${CATE_NAME} == ${cate} ]; then
            echo "- [${TEST_NAME%.json}](https://godleon.github.io/osp_test_results/${RESOURCE_VER}/${cate}/${TEST_NAME%.json}.html)" | tee -a ${SUM_FILE}
        fi
    done

    echo "" | tee -a ${SUM_FILE}
done

git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Summary current test(${CURRENT_TEST}) for iteration - version ${RESOURCE_VER}"