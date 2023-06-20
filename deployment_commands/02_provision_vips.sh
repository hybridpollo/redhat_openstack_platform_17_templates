#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
UNDERCLOUD_RC_FILE="/home/stack/stackrc"
STACK_NAME="voltron"
VIP_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/vip_data.yaml"
VIP_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_vips.yaml"

if [[ $USER != "stack" ]]; then
  echo -e "ERROR: Deploy script  must be run as the stack user."
  exit 1
fi 

echo "Running the overcloud vips provisioning deployment."

if test -f "${UNDERCLOUD_RC_FILE}" ; then  
  source ${UNDERCLOUD_RC_FILE}
  cd /home/stack
else
  echo -e "Undercloud environment file: ${RC_FILE} does not exist!"
  exit 1
fi


###################################################                                                               
# Provision the overcloud vips command
###################################################    
openstack overcloud network vip provision --stack ${STACK_NAME} ${VIP_IN_FILE} --output ${VIP_OUT_FILE}

