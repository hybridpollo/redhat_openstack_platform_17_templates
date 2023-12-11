## Red Hat OpenStack Platform 17.1 General Purpose Deployment Templates ##

**Contributors:**      Alberto Rivera Laporte | hybridpollo@proton.me | berto@redhat.com 

**Red Hat OpenStack Platform Release:** 17.1 Beta

## Disclaimers ##

As a Red Hat associate providing product configuration examples in this repository, it is my responsibility to advise the reader that the contents of this repository are provided to the community to use as-is and comes without expectation of support from Red Hat. That being said, they have been successfully tested in a well defined lab environment and I am confident that you can be successful in the deployment as long as you are familiar with the pre-deployment planning, and deployment procedure of a Red Hat OpenStack Platform environment.
This repository and templates contain information that may be viewed as of sensitive information such as IP addresses and self signed ssl certificates. Use caution when developing your own templates and do not unintentionally expose unwanted detail to unpriviledged eyes.

## Description ##
Red Hat OpenStack Platform 17 is the latest major version of Red Hat's opinionated installation for OpenStack released in September, 2022 as GA release. This repository contains a collection of templates developed to deploy a Red Hat OpenStack Platform 17 in a general purpose compute node deployment.

## Reference Architecture ##
The reference architecture for this deployment contains the following host roles:

* 1 x Undercloud Node
* 3 x Overcloud Controllers
* 2 x Overcloud Compute Nodes

## Overcloud Features ##
* Neutron ML2/OVN networking(non-dvr)
* SSL/TLS encrypted public endpoints
* Predictable overcloud node baremetal deployment
* Predictable overcloud node host names
* Predictable overcloud node ip addresses
* Predictable overcloud endpoint virtual ips
* Custom disk partitioning for deployed nodes
* Custom root password injection for deployed nodes
* Custom storage backend using an NFS backend for Glance images
* Custom storage backend using an NFS backend for Cinder volumes 
* Compute service uses local storage for ephemeral / root disks of OpenStack instances

## Repository Structure ##
```
.
├── README.md
├── deployment_commands
│   ├── 01_provision_networks.sh
│   ├── 02_provision_vips.sh
│   ├── 03_provision_baremetal_nodes.sh
│   ├── 04_overcloud_deploy.sh
│   └── 05_delete_overcloud.sh
└── deployment_templates
    ├── baremetal_node_deployment
    │   ├── baremetal_deployment.yaml
    │   ├── network_data.yaml
    │   ├── network_templates
    │   │   ├── compute.j2
    │   │   └── controller.j2
    │   └── vip_data.yaml
    └── overcloud_software_deployment
        ├── container_image_prepare.yaml
        ├── customizations.yaml
        ├── deployed_baremetal_nodes.yaml
        ├── deployed_networks.yaml
        ├── deployed_vips.yaml
        ├── enable_tls.yaml
        ├── inject_trust_anchor.yaml
        ├── roles_data.yaml
        ├── ssh_banner.yaml
        └── storage_config.yaml
```

## Repository Directory Details ##

**deployment_commands**

This directory contains a collection of shell scripts used for the various deployment stages of an Red Hat OpenStack Platform 17.1 deployment. This can be used as an aid to assist you in understanding the sequence of procedures making up an overcloud deployment.

**deployment_templates/baremetal_node_deployment**

This directory contains environment files which are used prior to the actual deployment of the Overcloud software components. Red Hat OpenStack Platform 17 Overcloud deployments now segmented into independent commands for the various stages of the deployment. In contrast, previous versions of Red Hat OpenStack Platform deployments relied in a single deployment command to provision the baremetal nodes, Ceph storage components, and the Overcloud software components. The high level deployment workflow is explained further below. 

**deployment_templates/overcloud_software_deployment**

This directory contains environment files which are used as input environment files for the Overcloud deployment. Some of these files are automatically rendered during one of the pre-deployment commands, while other environment templates are user customized environment files providing the
desired features and functionality.

## High Level Deployment Procedure ##
* Configure and deploy the Undercloud. This procedure is the same as previous versions of the Red Hat OpenStack Platform.
* Register, inspect, and clean the baremetal nodes. This procedure is the same as previous versions of the Red Hat OpenStack Platform.
* Provision Overcloud networks. This procedure is new in Red Hat OpenStack Platform 17. This procedure generates an environment file used for the Overcloud deployment.
* Provision Overcloud service virtual ips. This procedure is new in Red Hat OpenStack Platform 17. This procedure generates an environment file used for the Overcloud deployment.
* Provision the baremetal nodes. This procedure is new in Red Hat OpenStack Platform 17. This procedure generates an environment file used for the Overcloud deployment.
* Deploy the Overcloud software. This procedure is the same as previous version of the Red Hat OpenStack Platform.

##  Deployment Procedure Example ##
Pre-Requisites
* Deployed Undercloud
* Baremetal nodes registered, inspected, and clean.

**A. Provision the Overcloud networks**
```
# variables to keep the command line example concise
STACK_NAME="overcloud"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
NET_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"
NET_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_networks.yaml"

openstack overcloud network provision --stack ${STACK_NAME} \
${NET_IN_FILE} --output ${NET_OUT_FILE}
```
The output file is deployed_networks.yaml. This file will be used as input for the Overcloud deployment.

**B. Provision the Overcloud vips**
```
# variables to keep the command line example concise
STACK_NAME="overcloud"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
VIP_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/vip_data.yaml"
VIP_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_vips.yaml"

openstack overcloud network vip provision --stack ${STACK_NAME} ${VIP_IN_FILE} \
--output ${VIP_OUT_FILE}
```
The output file is deployed_vips.yaml. This file will be used as input for the Overcloud deployment.

**C. Provision the baremetal nodes**
```
# variables to keep the command line example concise
STACK_NAME="overcloud"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
BM_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
BM_OUT_FILE="${THT_CUSTOM}/overcloud_software_deployment/deployed_baremetal_nodes.yaml"

openstack overcloud node provision --stack ${STACK_NAME} \
--network-config ${BM_IN_FILE} \
--output ${BM_OUT_FILE}
```
Take time to explore the baremetal_deployment.yaml file. This file is responsible for defining the Overcloud roles, role counts, networks, predictable node placement, predictable hostnames,predictable ips, network configuration, custom disk partitioning and other customizations. This file is use as input for this command which will trigger the baremetal node provisioning of the Overcloud nodes defined in this file. If successful, by the time this procedure is complete, you will have a complete baremetal node deployment with the configured OpenStack infrastructure networks. The output file is deployed_baremetal_nodes.yaml. This file will be used as input for the Overcloud deployment.


**D. Deploy the Overcloud**
At this stage you should have:
* Running and functioning Undercloud
* Deployed and configured baremetal Overcloud nodes

To deploy the Overcloud, use the `openstack overcloud deploy` commmand followed by a collection of environment files generated in previous steps in addition to including the TripleO default environment files for the desired services:

```                                      
# Generic variables used for 
STACK_NAME="overcloud"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"

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
```

The Overcloud deployment procedure is divided into two major workflows:
* Installs the Overcloud software defined artifacts in the Undercloud via an ephemeral heat stack. During this procedure the heat templates are validated of their syntax and the Overcloud configuration artifacts are stored within the Underclouds deployment plan.
* The TripleO deployer will use config-download to render these artifacts stored within the Underclouds deployment plan and utilizes Ansible to configure the Overcloud components. 

This procedure is the same as Red Hat OpenStack Platform 16 but worth mentioning the workflow.


## Deleting the Overcloud ##
Deleting the Overcloud utilizes the same command as previous versions of Red Hat OpenStack Platform. 
```
STACK_NAME="overcloud"
THT_DEFAULT="/usr/share/openstack-tripleo-heat-templates"
THT_CUSTOM="/home/stack/rhosp_deployment/overcloud/deployment_templates"
BM_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/baremetal_deployment.yaml"
NET_IN_FILE="${THT_CUSTOM}/baremetal_node_deployment/network_data.yaml"

###################################################                                                               
# Delete the overcloud
###################################################    
openstack overcloud delete ${STACK_NAME} -b ${BM_IN_FILE} \
--networks-file ${NET_IN_FILE} \
--network-ports 
```


