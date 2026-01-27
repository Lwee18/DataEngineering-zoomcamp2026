# Local Data Infrastructure with Terraform & MinIO

This project is a hands-on practice environment for managing local cloud-like infrastructure using **Terraform** and **Docker**

## How it Works

The Terraform configuration in this repository performs the following:
1. **Containerizarion**: Pulls the latest MinIO image and lacunhed a docker container.
2. **Resilience**: Implements a `null_resource` with a **15-second sleep** timer to ensure the MinIO server is fully initialized before Terraform attempts to create S3 resources.
3. **Automation**: Automatically creates an S3 bucket and uploads a NYC Taxi Parquet file (`yellow_tripdata_2021-08.parquet`) into the bucket.


## Prerequisites

1. **Docker** installed and running on the machine.
2. **Terraform** installed.
3. A sample file located at `./files/yellow_tripdata_2021-08.parquet`.


## Configuration (Security)

This project used **Sensitive Variables** to keep credentials out of the source code. These enviroment variables must be set in the terminal before running Terraform:

```bash
export TF_VAR_minio_root_user="admin"
export TF_VAR_minio_root_password="password123"
```

## Usage
### 1.Initialize the project
```bash
terraform init
```
### 2.Apply the configuration
```bash
terraform apply
```
### 3.Access the MinIO Console:
Open http://localhost:9001 in your browser and log in using the credentials that were exported in the previous step.

## Project Structure
* **main.tf**: Defines the Docker and MinIO resources.
* **variables.tf**: Defines the required sensitive inputs.
* **files/**: Directory containing the data files to be uploaded.

## Troubleshooting
If an error regarding Docker API version mismatch is encountered (e.g., *please upgrade your client to a newer version*), it can be forced to match the Docker Engine Version.

Add a file `/etc/docker/daemon.json`, containing:
```json
{"min-api-version": "1.32"}
```

### Reference
[Docker error about "client API version"](https://stackoverflow.com/questions/79817033/sudden-docker-error-about-client-api-version)