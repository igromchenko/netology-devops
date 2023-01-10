terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
resource "yandex_compute_instance" "vm" {
  count       = var.nodes_count
  name        = "rmq0${count.index + 1}"
  hostname    = "rmq0${count.index + 1}"
  platform_id = "standard-v2"
  scheduling_policy {
    preemptible = true
  }
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8hpqvd8id5l4gb74t2"
      size     = 3
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    ip_address = "192.168.0.10${count.index + 1}"
    nat        = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
resource "yandex_vpc_network" "network" {
  name = "network"
}
resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}
resource "local_file" "inventory" {
  content  = "%{for vm in yandex_compute_instance.vm}${vm.hostname} ansible_host=${vm.network_interface.0.nat_ip_address}\n%{endfor}"
  filename = "inventory"
}