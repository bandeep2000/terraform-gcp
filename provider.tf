provider "google" {
  //credentials = "${file("/var/lib/jenkins/credentials/sap-ariba-prod-au2-bootstrap.json")}"
  version = "~> 1.19"

  //credentials = "${file("test/sap-ariba-prod-transit-52443a67123d.json")}"
  credentials = "${file("/var/accounts/account-cobalt.json")}"
  project     = "${var.project}"

  region      = "${var.region_id}"
}
