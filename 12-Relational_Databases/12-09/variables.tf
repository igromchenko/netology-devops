variable "token" {
  description = "Yandex.Cloud OAuth access token"
}

variable "cloud_id" {
  description = "Yandex.Cloud cloud_id"
}

variable "folder_id" {
  description = "Yandex.Cloud folder_id"
}

variable "pg_password" {
  description = "PostgreSQL DB owner password"
  default     = "postgres"
}