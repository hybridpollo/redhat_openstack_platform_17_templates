#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
BM_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
BM_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_baremetal_nodes.yaml"

# load the stackrc file environment variables for the undercloud
source /home/stack/stackrc

###################################################                                                               
# Provision the baremetal node command
###################################################    
openstack overcloud node provision --stack ${STACK_NAME} --network-config \
${BM_IN_FILE} --output ${BM_OUT_FILE}

