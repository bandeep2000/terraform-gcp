//https://github.wdf.sap.corp/Ariba-ces/bootstrap/blob/develop/modules/compute/cdh/modules/instance/main.tf
# Boot disk for VM
resource "google_compute_disk" "boot-disk" {
  count = "${var.vm_count}"
  name  = "${var.prefix}-boot-disk-influx-${count.index}"
  type  = "pd-ssd"
  zone  = "${var.zone}"
  size  = "10"
  image = "${var.image}"
}

# standard persistent disk (not ssd ) for influx data
resource "google_compute_disk" "influx-data" {
  count = "${var.vm_count}"
  name  = "${var.prefix}-influx-data-terraform"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "600"
  
}

# ssd persistence disk wal
resource "google_compute_disk" "influx-wal" {
  count = "${var.vm_count}"
  name = "${var.prefix}-influx-wal-terraform"
  type = "pd-ssd"
  zone = "${var.zone}"
  size = "100"

  labels = {
    environment = "influx"
  }
}

# Create VM now
resource "google_compute_instance" "default" {
  depends_on   = ["google_compute_disk.influx-wal","google_compute_disk.boot-disk"]
  name         = "${var.prefix}-terraform-influx"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  tags = ["influx"]

  boot_disk {
    source = "${google_compute_disk.boot-disk.*.self_link[count.index]}"
  }

  /*boot_disk {
    initialize_params {
      //image = "rhel-6-v20190213"
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
    
    source      = "${google_compute_disk.influx-wal.*.self_link[count.index]}"
    device_name = "${var.prefix}-influx-wal-terraform"
  }

  attached_disk {
    source      = "${google_compute_disk.influx-data.*.self_link[count.index]}"
    device_name = "${var.prefix}-influx-data-terraform"
  }
  metadata = {
    foo = "bar"
  }
  metadata_startup_script = "echo hi > /test.txt"
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}



