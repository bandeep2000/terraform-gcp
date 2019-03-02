//https://github.wdf.sap.corp/Ariba-ces/bootstrap/blob/develop/modules/compute/cdh/modules/instance/main.tf
variable "vm_count" {
  default = "1"
}

# Boot disk for VM
resource "google_compute_disk" "boot-disk" {
  count = "${var.vm_count}"
  name  = "boot-disk-influx-${count.index}"
  type  = "pd-ssd"
  zone  = "us-west1-a"
  size  = "10"
  image = "rhel-6-v20190213"
}

# standard persistent disk (not ssd ) for influx data
resource "google_compute_disk" "influx-data" {
  count = "${var.vm_count}"
  name  = "ban-influx-data-terraform"
  type  = "pd-standard"
  zone  = "us-west1-a"
  size  = "600"
  
}

# ssd persistence disk wal
resource "google_compute_disk" "influx-wal" {
  name = "ban-influx-wal-terraform"
  type = "pd-ssd"
  zone = "us-west1-a"
  size = "100"

  labels = {
    environment = "influx"
  }
}

# Create VM now
resource "google_compute_instance" "default" {
  depends_on   = ["google_compute_disk.influx-wal","google_compute_disk.boot-disk"]
  name         = "ban-terraform-influx"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"

  tags = ["influx"]

  boot_disk {
    source = "${google_compute_disk.boot-disk.*.self_link[count.index]}"
  }

  /*boot_disk {
    initialize_params {
      image = "rhel-6-v20190213"
    }
  }
  */

  // Local SSD disk
  //scratch_disk {}
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  //labels = "influx"
  labels = {
    influx = "server"
  }

  attached_disk {
    source      = "${google_compute_disk.influx-wal.self_link}"
    device_name = "ban-influx-wal-terraform1"
  }

  attached_disk {
    source      = "${google_compute_disk.influx-data.self_link}"
    device_name = "ban-influx-data-terraform1"
  }
  metadata = {
    foo = "bar"
  }
  metadata_startup_script = "echo hi > /test.txt"
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

/*resource "google_compute_attached_disk" "default" {
//  disk = "${google_compute_disk.influx-wal.self_link}"
//  instance = "${google_compute_instance.default.self_link}"
}
*/

