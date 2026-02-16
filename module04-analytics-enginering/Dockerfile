FROM python:3.11-slim

# Install git (dbt needs it for packages)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip uninstall -y dbt-fusion dbt-core dbt-common dbt-adapters && pip install --no-cache-dir dbt-duckdb duckdb requests pandas

COPY . .

CMD ["bash"]