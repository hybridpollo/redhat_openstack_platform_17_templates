#!/usr/bin/env bash 
#
###################################################                                                               
# Variables
###################################################                                              
STACK_NAME="voltron"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/redhat_openstack_platform_17_templates/deployment_templates"

# load the stackrc file environment variables for the undercloud
source /home/stack/stackrc

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
  -e ${THT_CUSTOM}/overcloud_software_deployment/storage_config.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/satellite_registration.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/keystone_idm_integration.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_vips.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_networks.yaml \
  -e ${THT_CUSTOM}/overcloud_software_deployment/deployed_baremetal_nodes.yaml

