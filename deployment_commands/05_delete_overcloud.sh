#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_CUSTOM="/home/stack/redhat_openstack_platform_17_templates/deployment_templates"
BAREMETAL_NODE_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
NETWORK_DATA_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"


# load the stackrc file environment variables for the undercloud
source /home/stack/stackrc

###################################################                                                               
# Delete the undercloud 
###################################################    
openstack overcloud delete -b ${BAREMETAL_NODE_FILE} --networks-file ${NETWORK_DATA_FILE} --network-ports ${STACK_NAME}

