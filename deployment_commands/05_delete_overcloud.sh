#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
UNDERCLOUD_RC_FILE="/home/stack/stackrc"
STACK_NAME="voltron"
BAREMETAL_NODE_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
NETWORK_DATA_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"

if [[ $USER != "stack" ]]; then
  echo -e "ERROR: Deploy script  must be run as the stack user."
  exit 1
fi 

echo "Deleting the Overcloud: ${STACK_NAME}"

if test -f "${UNDERCLOUD_RC_FILE}" ; then  
  source ${UNDERCLOUD_RC_FILE}
  cd /home/stack
else
  echo -e "Undercloud environment file: ${RC_FILE} does not exist!"
  exit 1
fi


###################################################                                                               
# Delete the undercloud 
###################################################    
openstack overcloud delete -b ${BAREMETAL_NODE_FILE} --networks-file ${NETWORK_DATA_FILE} --network-ports ${STACK_NAME}

