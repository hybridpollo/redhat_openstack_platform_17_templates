#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
UNDERCLOUD_RC_FILE="/home/stack/stackrc"
STACK_NAME="voltron"

if [[ $USER != "stack" ]]; then
  echo -e "ERROR: Deploy script  must be run as the stack user."
  exit 1
fi 

echo "Running the overcloud deployment."

if test -f "${UNDERCLOUD_RC_FILE}" ; then  
  source ${UNDERCLOUD_RC_FILE}
  cd /home/stack
else
  echo -e "Undercloud environment file: ${RC_FILE} does not exist!"
  exit 1
fi


###################################################                                                               
# Deploy 
###################################################    
openstack overcloud deploy --stack ${STACK_NAME} --templates \
  -e ${THT_DEFAULT}/environments/disable-swift.yaml \
  -e ${THT_DEFAULT}/environments/disable-telemetry.yaml \
  -e ${THT_DEFAULT}/environments/services/neutron-ovn-ha.yaml \
  -e ${THT_DEFAULT}/environments/ssl/tls-endpoints-public-dns.yaml \
  -r ${THT_CUSTOM}/overcloud_software_deployment/roles_data.yaml \
  -n ${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/container_image_prepare.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/inject_trust_anchor.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/enable_tls.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/ssh_banner.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/customizations.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/storage_config.yaml  \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_vips.yaml  \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_networks.yaml  \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_baremetal_nodes.yaml


