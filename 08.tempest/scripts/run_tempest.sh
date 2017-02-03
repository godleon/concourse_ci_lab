#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script (run_tempest.sh) ================"

RESOURCE_VER=$(cat git-resource_semver_1/version)

# 註冊 Red Hat CDN
subscription-manager register --username ${REDHAT_USER_NAME} --password ${REDHAT_USER_PWD} --autosubscribe
subscription-manager attach --pool=${REDHAT_REG_POOLID}
subscription-manager repos --disable=*
subscription-manager repos ${REDHAT_REPO_ENABLED}

# 執行 Tempest 測試
yum -y install git openstack-tempest
mkdir /tempest
cd /tempest
ln -s /usr/share/openstack-tempest-13.0.0 /usr/share/openstack-tempest
#sed -i 's/heat_stack_owner/heat_stack_user/g' /usr/share/openstack-tempest/tools/config_tempest.py
#grep heat_stack /usr/share/openstack-tempest/tools/config_tempest.py
sh /usr/share/openstack-tempest/tools/configure-tempest-directory
#grep tools/config_tempest.py
tools/config_tempest.py --debug --create identity.uri ${OS_AUTH_URL} identity.admin_username ${OS_USERNAME} identity.admin_password ${OS_PASSWORD} identity.admin_tenant_name ${OS_TENANT_NAME} object-storage.operator_role swiftoperator
#python -m tempest.cmd.cleanup --init-saved-state
#tempest cleanup --init-saved-state

tools/run-tests.sh tempest.api.compute.flavors | tee ra-out.txt
#tools/run-tests.sh tempest.api.compute.flavors | tee ra-out.txt
#tools/run-tests.sh | tee ra-out.txt
#tempest cleanup
cd -

env
#echo "ANSIBLE_HOST_KEY_CHECKING = ${ANSIBLE_HOST_KEY_CHECKING}"

git clone git-resource_build tempest_output
cat git-resource_semver_1/version
find .

if [ -d tempest_output/${RESOURCE_VER} ]; then
    rm -rf tempest_output/${RESOURCE_VER}
    cd tempest_output
    git config --global user.email "nobody@concourse.ci"
    git config --global user.name "Concourse"
    git add -A
    git commit -m "Clean garbage file version ${RESOURCE_VER}"
    cd -
fi

mkdir -p tempest_output/${RESOURCE_VER}
cp /tempest/ra-out.txt tempest_output/${RESOURCE_VER}/
#cp git-resource_osp/08.tempest/raw_logs/ra-out.txt tempest_output/${RESOURCE_VER}/

cd tempest_output
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Tempest raw output version ${RESOURCE_VER}"