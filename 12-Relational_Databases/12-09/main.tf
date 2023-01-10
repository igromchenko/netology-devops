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
}

resource "yandex_mdb_postgresql_user" "igromchenko" {
  cluster_id = yandex_mdb_postgresql_cluster.test-netology.id
  name       = "igromchenko"
  password   = var.pg_password
}

resource "yandex_mdb_postgresql_database" "my_database" {
  cluster_id = yandex_mdb_postgresql_cluster.test-netology.id
  name       = "my_database"
  owner      = yandex_mdb_postgresql_user.igromchenko.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
}

resource "yandex_mdb_postgresql_cluster" "test-netology" {
  name        = "test-netology"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network.id
  host_master_name = "pg-a"
  config {
    version = 14
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 10
      disk_type_id       = "network-ssd"
    }
  }
  host {
    zone      = "ru-central1-a"
    name      = "pg-a"
    subnet_id = yandex_vpc_subnet.subnet-a.id
    assign_public_ip = true
  }
  host {
    zone      = "ru-central1-b"
    name      = "pg-b"
    subnet_id = yandex_vpc_subnet.subnet-b.id
    assign_public_ip = true
  }
  host {
    zone      = "ru-central1-c"
    name      = "pg-c"
    subnet_id = yandex_vpc_subnet.subnet-c.id
    assign_public_ip = true
  }
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet-a" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet-c" {
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.3.0/24"]
}