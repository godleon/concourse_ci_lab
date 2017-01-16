#!/bin/bash

source ${1}

subscription-manager register --username ${REDHAT_USERNAME} --password ${REDHAT_USERPASSWORD} --autosubscribe
subscription-manager attach --pool=${REDHAT_REG_POOLID}
subscription-manager repos --disable=*
subscription-manager repos --enable=${REDHAT_REPO_ENABLED}

yum -y install openstack-tempest
mkdir /tempest
cd /tempest
sh /usr/share/openstack-tempest-13.0.0/tools/configure-tempest-directory
tools/config_tempest.py --debug --create identity.uri ${OS_AUTH_URL} identity.admin_username ${OS_USERNAME} identity.admin_password ${OS_PASSWORD} identity.admin_tenant_name ${OS_TENANT_NAME} object-storage.operator_role Member
python -m tempest.cmd.cleanup --init-saved-state
python -m tempest.cmd.cleanup
tools/run-tests.sh | tee ra-out.txt