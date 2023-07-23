#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_CUSTOM="/home/stack/redhat_openstack_platform_17_templates/deployment_templates"
VIP_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/vip_data.yaml"
VIP_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_vips.yaml"


# load the stackrc file environment variables for the undercloud
source /home/stack/stackrc

###################################################                                                               
# Provision the overcloud vips command
###################################################    
openstack overcloud network vip provision --stack ${STACK_NAME} ${VIP_IN_FILE} --output ${VIP_OUT_FILE}

