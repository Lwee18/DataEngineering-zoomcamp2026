# dbt + DuckDB Analytics Engineering Environment

(Data Engineering Zoomcamp 2026 -- Module 04)

This project provides a reproducible analytics engineering environment
using Docker, dbt, and DuckDB. It includes a Python ingestion pipeline
that downloads NYC Taxi datasets, converts them into Parquet files, and
loads them into a DuckDB database for analytics and transformation
workflows.

The setup supports two development styles: - Running inside Docker from
the terminal - Developing inside VS Code using a Dev Container

------------------------------------------------------------------------

## Project Overview

This setup includes: - Docker container with Python, dbt, DuckDB, and
dependencies - dbt analytics project inside `taxi_rides_ny/` - Data
ingestion script in `scripts/` - Docker Compose service for interactive
development - VS Code Dev Container for a full IDE experience

------------------------------------------------------------------------

## Prerequisites

Install the following tools:

-   Docker
-   Docker Compose
-   VS Code 
-   VS Code Dev Containers extension

------------------------------------------------------------------------

## Project Structure
```text
module04-analytics-enginering/
│
├── docker-compose.yml
├── Dockerfile
├── scripts/
│ └── ingest_data.py
├── taxi_rides_ny/
│ └── dbt project files
└── .devcontainer/
└── devcontainer.json
```
------------------------------------------------------------------------

## Docker Environment

### Build Docker Image

```bash
docker compose build
```
------------------------------------------------------------------------

### Start Interactive Container

```bash
 docker compose run --rm dbt-env
```

Working directory inside container: `/app/taxi_rides_ny`

------------------------------------------------------------------------

## Data Ingestion Pipeline

The ingestion script performs:

1.  Downloads NYC Taxi CSV files
2.  Converts CSV files into Parquet using DuckDB
3.  Removes raw CSV files to save storage
4.  Creates persistent DuckDB database
5.  Loads datasets into schema `prod`

------------------------------------------------------------------------

### Run Ingestion

Inside container:

```bash
 python ../scripts/ingest_data.py
```

Output: - `taxi_rides_ny/data/` - `taxi_rides_ny.duckdb`

------------------------------------------------------------------------


# Dev Container Setup (Optional)

This document explains how to configure and use the VS Code Dev
Container for the dbt + Duckdb Zoomcamp analytics engineering
environment.

------------------------------------------------------------------------

## Overview

The Dev Container allows you to develop inside the same Docker
environment defined in docker-compose.yml without manually starting
containers.

It will:

-   Use the existing dbt-env service
-   Mount the project into the container
-   Set workspace to /app/taxi_rides_ny
-   Configure Python and dbt automatically
-   Install required VS Code extensions

------------------------------------------------------------------------

## Step 1 --- Create Dev Container Folder

From the project root:
```bash
 mkdir .devcontainer
 cd .devcontainer
```

------------------------------------------------------------------------

## Step 2 --- Create devcontainer.json

Create a file named:

```bash
.devcontainer/devcontainer.json
```

Paste the following configuration:

```bash
{
    "name": "Dbt Zoomcamp Dev",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "dbt-env",
    "workspaceFolder": "/app/taxi_rides_ny",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "innoverio.vscode-dbt-power-user",
                "tamasfe.even-better-toml",
                "me-akshay-ly.duckdb-sql",
                "njpwerner.autodocstring"
            ],
            "settings": {
                "python.defaultInterpreterPath": "/usr/local/bin/python",
                "dbt.profilesDir": "/app/taxi_rides_ny",
                "dbt.projectDir": "/app/taxi_rides_ny",
                "editor.formatOnSave": true
            }
        }
    },
    "remoteUser": "root"
}
```

------------------------------------------------------------------------

## Step 3 --- Install Dev Containers Extension

Install in VS Code: `Dev Containers`

Docker must be running on the system.

------------------------------------------------------------------------

## Step 4 --- Open Project in Dev Container

1.  Open project folder in VS Code
2.  Press Ctrl + Shift + P
3.  Select: Dev Containers: Reopen in Container

------------------------------------------------------------------------

## Step 5 --- Automatic Setup

VS Code will:

-   Build Docker image if required
-   Start dbt-env service
-   Mount project into /app
-   
-   Open workspace at /app/taxi_rides_ny

------------------------------------------------------------------------
