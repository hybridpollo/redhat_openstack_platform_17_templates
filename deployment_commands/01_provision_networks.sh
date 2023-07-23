#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_CUSTOM="/home/stack/redhat_openstack_platform_17_templates/deployment_templates"
NET_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"
NET_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_networks.yaml"

# load the stackrc file environment variables for the undercloud
source /home/stack/stackrc

###################################################                                                               
# Provision the overcloud networks command
###################################################    
openstack overcloud network provision --stack ${STACK_NAME} ${NET_IN_FILE} --output ${NET_OUT_FILE}

