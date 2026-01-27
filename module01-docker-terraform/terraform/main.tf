terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    minio = {
      source  = "aminueza/minio"
      version = ">= 1.0.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "minio_server" {
  name    = "local_minio_server"
  image   = "quay.io/minio/minio:latest"
  command = ["server", "/data", "--console-address", ":9001"]

  volumes {
    host_path      = "${path.cwd}/minio_data"
    container_path = "/data"
  }

  ports {
    internal = 9000
    external = 9000
  }
  ports {
    internal = 9001
    external = 9001
  }
  # env = [
  #   "MINIO_ROOT_USER=admin",
  #   "MINIO_ROOT_PASSWORD=password123"
  # ]

  env = [
    "MINIO_ROOT_USER=${var.minio_root_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_root_password}"
  ]

}

provider "minio" {
  minio_server   = "localhost:9000"
  minio_user     = var.minio_root_user
  minio_password = var.minio_root_password
  minio_ssl      = false
}

resource "null_resource" "wait_for_minio" {
  depends_on = [docker_container.minio_server]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}


resource "minio_s3_bucket" "l_bucket" {
  bucket        = "s3-terraform-local-bucket"
  force_destroy = true

  depends_on = [null_resource.wait_for_minio]
}


resource "minio_s3_object" "nyc_file" {
  bucket_name  = minio_s3_bucket.l_bucket.bucket
  object_name  = "yellow_tripdata_2021-08.parquet"
  source       = "${path.module}/files/yellow_tripdata_2021-08.parquet"
  content_type = "application/octet-stream"
}
