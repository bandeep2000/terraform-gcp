provider "google" {
  //credentials = "${file("/var/lib/jenkins/credentials/sap-ariba-prod-au2-bootstrap.json")}"
  version = "~> 1.19"

  //credentials = "${file("test/sap-ariba-prod-transit-52443a67123d.json")}"
  credentials = "${file("account-cobalt.json")}"
  project     = "sap-ariba-cobalt"

  //region      = "${var.region_id}"
}
