output "cdh-bootstrap-reserved-ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

output "cdh-bootstrap-reserved-name" {
  value = "${google_compute_instance.default.id}"
}
