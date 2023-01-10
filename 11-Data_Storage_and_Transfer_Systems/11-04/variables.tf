variable "token" {
  description = "Yandex.Cloud OAuth access token"
}
variable "cloud_id" {
  description = "Yandex.Cloud cloud_id"
}
variable "folder_id" {
  description = "Yandex.Cloud folder_id"
}
variable "zone" {
  description = "Yandex.Cloud Availability zone"
  default     = "ru-central1-a"
}
variable "nodes_count" {
  description = "RabbitMQ cluster nodes count"
  default     = 3
}