output "ip" {
  value = "${google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip[0]}"
}

output "name" {
  value = "${google_compute_instance.default.*.id[0]}"
}
