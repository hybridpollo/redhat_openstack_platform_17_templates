#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
BAREMETAL_NODE_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
NETWORK_DATA_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"

source /home/stack/stackrc

###################################################                                                               
# Delete the undercloud 
###################################################    
openstack overcloud delete -b ${BAREMETAL_NODE_FILE} --networks-file ${NETWORK_DATA_FILE} --network-ports ${STACK_NAME}

