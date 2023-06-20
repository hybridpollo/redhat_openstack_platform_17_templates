#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
UNDERCLOUD_RC_FILE="/home/stack/stackrc"
STACK_NAME="voltron"
NET_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"
NET_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_networks.yaml"

if [[ $USER != "stack" ]]; then
  echo -e "ERROR: Deploy script  must be run as the stack user."
  exit 1
fi 

echo "Running the overcloud network provisioning deployment."

if test -f "${UNDERCLOUD_RC_FILE}" ; then  
  source ${UNDERCLOUD_RC_FILE}
  cd /home/stack
else
  echo -e "Undercloud environment file: ${RC_FILE} does not exist!"
  exit 1
fi


###################################################                                                               
# Provision the overcloud networks command
###################################################    
openstack overcloud network provision --stack ${STACK_NAME} ${NET_IN_FILE} --output ${NET_OUT_FILE}

