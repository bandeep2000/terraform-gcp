terraform {
  backend "gcs" {
    bucket      = "ban-terraform2"
    credentials = "/var/accounts/account-cobalt.json"
    prefix      = "test-terraform-influx"
  }
}
