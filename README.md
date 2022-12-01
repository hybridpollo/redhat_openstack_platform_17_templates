# Red Hat OpenStack Platform 17.0 Hyperconverged Deployment Test Templates #


# Disclaimers #
**Contributors:**      Alberto Rivera Laporte | hybridpollo@proton.me
**Red Hat OpenStack Platform Release:** 17.0
**Red Hat Ceph Storage Release:** 5.0
**Current Template Revision:** 0.0.1
**Additional Remarks:** As a Red Hat associate, providing product configuration examples in this repository, it is my responsibility to advise the reader the contents of this repository are provided to the community to use as-is and comes without expectation of support of Red Hat, or myself. That being said, they have been successfully tested in a well defined lab environment and I am confident that you too can be successful in the deployment as long as you are familiar with the deployment planning requisites and suitable deployment procedure of a Red Hat OpenStack Platform deployment.

These deployment templates have been developed for the use of Hyperconverged deployment scenarios. Additional deployment scenarios will be available in the future as a distinct branch of this repository.

This repository and templates contain information that may be viewed as of sensitive information such as IP addresses and self signed ssl certificates. Use caution when developing your own templates and do not unintentionally expose unwanted detail to unpriviledged eyes.

## Description ##
Red Hat OpenStack Platform 17.0 is the latest major version of Red Hat's opinionated installation for OpenStack released in September, 2022. This repository contains a collection of templates developed to deploy a Red Hat OpenStack Platform 17 in a Hyperconverged compute node deployment.

The intention of these templates is to familiarize myself and other OpenStack operators with this major release of the platform.

## Reference Architecture ##
The reference architecture for this deployment contains the following host roles:

* 1 x Undercloud Node
* 3 x Overcloud Controllers
* 5 x Overcloud Hyperconverged Compute Nodes
  * 2 x SSDs (Operating System)
  * 8 x HDDs (Ceph Storage Disks)

## Overcloud Features ##
* Neutron ML2/OVN networking(non-dvr)
* SSL/TLS encrypted public endpoints
* Predictable baremetal node hostnames
* Predictable overcloud node baremetal deployment
* Predictable overcloud node ip addresses
* Predictable overcloud endpoint virtual ips
* Hyperconverged compute and storage
  * At-rest-encryption for Ceph storage devices
  * Ceph RADOS Gateway
  * Ceph RBD storage for OpenStack images
  * Ceph RBD storage for OpenStack virtual machines
  * Ceph RBD storage for OpenStack block storage volumes

## Repository Directory Structure ##
```
├── 00_overcloud_deployment_common
│   ├── container_image_prepare.yaml
│   ├── network_data.yaml
│   ├── roles_data.yaml
│   └── vip_data.yaml
├── 01_overcloud_deployment_pre
│   ├── baremetal_deployment.yaml
│   ├── initial-ceph.conf
│   ├── network_templates
│   │   ├── compute.j2
│   │   └── controller.j2
│   └── osd_spec.yaml
├── 02_overcloud_deployment
│   ├── overcloud_customizations.yaml
│   ├── overcloud_deployed_ceph.yaml
│   ├── overcloud_deployed_networks.yaml
│   ├── overcloud_deployed_nodes.yaml
│   ├── overcloud_deployed_vips.yaml
│   ├── overcloud_enable_tls.yaml
│   ├── overcloud_inject_trust_anchor.yaml
│   └── overcloud_storage_config.yaml
└── README.md
```

## Repository Directory Details ##

**00_overcloud_deployment_common**
This directory contains environment files used through the various stages of the deployment and are the genesis to any OpenStack deployment

**01_overcloud_deployment_pre**
This directory contains environment files which are used prior to the actual deployment of the Overcloud software components. Red Hat OpenStack Platform 17.0 Overcloud deployment including the baremetal provisioning procedure and Ceph deployment are now segmented into independent, user-initiated Ansible driven plays for the various stages of the deployment. In contrast, previous versions of Red Hat OpenStack Platform deployments relied in a single deployment command to provision the baremetal nodes, Ceph storage components, and the Overcloud software components in the event where you are not using pre-deployed baremetal nodes.

**02_overcloud_deployment**
This directory contains environment files which are used as input files for the Overcloud deployment. Some of these files are user generated while some are generated during dring the pre-provisioning process.

A separate section below contains the deployment steps example commands.

## High Level Deployment Procedure ##
* Configure and deploy the Undercloud. This procedure is the same as previous versions of RHOSP.
* Register, inspect, and clean the baremetal nodes. This procedure is the same as previous versions of RHOSP.
* Provision Overcloud networks. This procedure is new in RHOSP17.
* Provision Overcloud service virtual ips. This procedure is new in RHOSP17.
* Provision the baremetal nodes. This procedure is new in RHOSP17.
* Deploy the ceph cluster. This procedure previously driving by Mistral workflows is new in RHOSP17.
* Deploy the Overcloud software. This procedure is the same as previous version of RHOSP

##  Deployment Procedure Example ##
Pre-Requisites
* Deployed Undercloud
* Baremetal nodes registered, inspected, and clean.
*

A. Provision the Overcloud Networks
```
openstack overcloud network provision \
--output 02_overcloud_deployment/overcloud_deployed_networks.yaml \
00_overcloud_deployment_common/network_data.yaml
```
The output file is overcloud_deployed_networks.yaml. This file will be used as input for the Ceph deployment and Overcloud deployment.

B. Provision the Overcloud VIPs
```
openstack overcloud network vip provision --stack overcloud \
--output 02_overcloud_deployment/overcloud_deployed_vips.yaml \
00_overcloud_deployment_common/vip_data.yaml
```
The output file is overcloud_deployed_vips.yaml. This file will be used as input for the Ceph deployment and Overcloud deployment.

C. Provision the baremetal nodes
```
openstack overcloud node provision --stack overcloud --network-config  \
--output 02_overloud_deployment/overcloud_deployed_nodes.yaml \
01_overcloud_deployment_pre/baremetal_deployment.yaml
```
Take time to explore the baremetal_deployment.yaml file. This file is responsible for defining the Overcloud roles, role counts, networks, predictable node placement, predictable hostnames, and predictable ips. This file is use as input for this command which will trigger the baremetal node provisioning of the Overcloud nodes defined in this file. If successful, by the time this procedure is complete, you will have a complete baremetal node deployment with the configured OpenStack infrastructure networks.  The output file is overcloud_deployed_nodes.yaml. This file will be used as input for the Ceph deployment and Overcloud deployment.

D. Provision the Ceph cluster
```
openstack overcloud ceph deploy \
--config 01_overcloud_deployment_pre/initial-ceph.conf \
--osd-spec 01_overcloud_deployment_pre/osd_spec.yaml \
--roles-data 00_overcloud_deployment_common/roles_data.yaml \
--network-data 00_overcloud_deployment_common/network_data.yaml \
--container-image-prepare 00_overcloud_deployment_common/container_image_prepare.yaml \
-o 02_overcloud_deployment/overcloud_deployed_ceph.yaml \
02_overcloud_deployment/overcloud_deployed_nodes.yaml
```
Explore the environment files described in this deployment command. This command will deploy the Red Hat Ceph Storage components. Ceph service placement is determined by the TripleO services defined in the roles_data.yaml file using an OSD service specification file used for the adjustments of Ceph OSD deployments. By the time this command completes, you will have a Ceph Monitors, Ceph Managers, Ceph OSDs deployed and a Ceph cluster bootstrapped and ready to use. Additional Ceph services such as Ceph pools for OpenStack and other configuration definitions and additional Ceph services will be implemented during the Overcloud deployment. The output file is overcloud_deployed_ceph.yaml. This file will be used for the Overcloud deployment.


E. Deploy the Overcloud
At this stage you should have:
* Deployed and configured baremetal Overcloud nodes
* Deployed and configured ceph cluster in the deployed Overcloud nodes

To deploy the Overcloud, use the `openstack overcloud deploy` commmand followed by a collection of environment files generated in previous steps in addition to including the TripleO default environment files for the desired services:

```
openstack overcloud deploy --templates \
-e /usr/share/openstack-tripleo-heat-templates/environments/cephadm/cephadm.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/disable-swift.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-ha.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-dns.yaml \
-n 00_overloud_deployment_common/network_data.yaml \
-r 00_overcloud_deployment_common/roles_data.yaml \
-e 01_overcloud_deployment_common/container_image_prepare.yaml \
-e 02_overcloud_deployment/overcloud_inject_trust_anchor.yaml \
-e 02_overcloud_deployment/overcloud_enable_tls.yaml \
-e 02_overcloud_deployment/overcloud_storage_config.yaml \
-e 02_overcloud_deployment/overcloud_deployed_ceph.yaml \
-e 02_overcloud_deployment/overcloud_deployed_vips.yaml \
-e 02_overcloud_deployment/overcloud_deployed_networks.yaml \
-e 02_overcloud_deployment/overcloud_deployed_nodes.yaml \
-e 02_overcloud_deployment/overcloud_customizations.yaml
```

## Changelog ##

### 0.0.1
* Initial commit of the templates
