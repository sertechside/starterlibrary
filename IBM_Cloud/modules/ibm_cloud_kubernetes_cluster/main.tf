provider "ibm" {
  region = "${var.region}"
  version = "~> 0.10"
}

data "ibm_org" "org" {
  org = "${var.org}"
}

data "ibm_space" "space" {
  org   = "${var.org}"
  space = "${var.space}"
}

data "ibm_account" "account" {
  org_guid = "${data.ibm_org.org.id}"
}

resource "ibm_container_cluster" "kubecluster" {
  name         = "${var.cluster_name}"
  datacenter   = "${var.datacenter}"
  org_guid     = "${data.ibm_org.org.id}"
  space_guid   = "${data.ibm_space.space.id}"
  account_guid = "${data.ibm_account.account.id}"
  machine_type = "${var.machine_type}"
  public_vlan_id = "${var.public_vlan_id}"
  private_vlan_id = "${var.private_vlan_id}"
  subnet_id = "${var.subnet_id}"
  #no_subnet    = true

  workers = "${var.workers[var.num_workers]}"
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = "${ibm_container_cluster.kubecluster.name}"
  org_guid        = "${data.ibm_org.org.id}"
  space_guid      = "${data.ibm_space.space.id}"
  account_guid    = "${data.ibm_account.account.id}"
}

################################################
# Find worker IP addresses
################################################
data "ibm_container_cluster" "cluster" {
  cluster_name_id             = "${ibm_container_cluster.kubecluster.name}"
  org_guid                    = "${data.ibm_org.org.id}"
  space_guid                  = "${data.ibm_space.space.id}"
  account_guid                = "${data.ibm_account.account.id}"
}

data "ibm_container_cluster_worker" "cluster_workers" {
  count                       = "1"
  worker_id                   = "${element(data.ibm_container_cluster.cluster.workers, count.index)}"
  org_guid                    = "${data.ibm_org.org.id}"
  space_guid                  = "${data.ibm_space.space.id}"
  account_guid                = "${data.ibm_account.account.id}"
}

########################################################################################
# Location of the cluster private key as read from the file it's been saved into locally
########################################################################################
data "external" "certificate_authority_location" {
  program = ["sh", "${path.module}/scripts/get-ca.sh"]

  query = {
    command = "echo $(dirname \"${data.ibm_container_cluster_config.cluster_config.config_file_path}\")/`grep certificate-authority ${data.ibm_container_cluster_config.cluster_config.config_file_path} | cut -d \":\" -f 2 | tr -d '[:space:]' ` > certificate_authority_location",
    cluster = "${var.cluster_name}"
  }
}