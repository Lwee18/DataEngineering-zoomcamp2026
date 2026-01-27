
variable "minio_root_user" {
  description = "The MinIO root user"
  type        = string
  sensitive   = true
}

variable "minio_root_password" {
  description = "The MinIO root password"
  type        = string
  sensitive   = true

}