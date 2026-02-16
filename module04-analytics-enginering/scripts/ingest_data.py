import duckdb
import requests
from pathlib import Path

# BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"
BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

# https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-01.csv.gz
# https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-01.csv.gz

PROJECT_DIR = Path("/app/taxi_rides_ny")
DB_PATH = PROJECT_DIR / "taxi_rides_ny.duckdb"
DATA_DIR = PROJECT_DIR / "data"

def download_and_convert_files(taxi_type):

    target_dir = DATA_DIR / taxi_type
    target_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019, 2020, 2021]:
        for month in range(1, 13):
            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = target_dir / parquet_filename

            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download CSV.gz file
            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = target_dir / csv_gz_filename

            response = requests.get(f"{BASE_URL}/{taxi_type}/{csv_gz_filename}", stream=True)
            response.raise_for_status()

            with open(csv_gz_filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Converting {csv_gz_filename} to Parquet...")
            con = duckdb.connect()
            con.execute(f"""
                COPY (SELECT * FROM read_csv_auto('{csv_gz_filepath}'))
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            con.close()

            # Remove the CSV.gz file to save space
            csv_gz_filepath.unlink()
            print(f"Completed {parquet_filename}")

def update_gitignore():
    gitignore_path = Path("/app/.gitignore")

    # Read existing content or start with empty string
    content = gitignore_path.read_text() if gitignore_path.exists() else ""

    # Ignore both the raw data and the duckdb database
    to_ignore = ['taxi_rides_ny/data/', '*.duckdb', '*.duckdb.wal']
    
    new_lines = []
    for item in to_ignore:
        if item not in content:
            new_lines.append(item)
    
    if new_lines:
        with open(gitignore_path, 'a') as f:
            f.write('\n' + '\n'.join(new_lines) + '\n')

if __name__ == "__main__":
    # Update .gitignore to exclude data directory
    update_gitignore()

    # for taxi_type in ["yellow", "green"]:
    #     download_and_convert_files(taxi_type)
    download_and_convert_files("fhv")
    # Connect to the persistent database file
    print(f"Loading data into {DB_PATH}...")
    con = duckdb.connect(str(DB_PATH))
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    con.execute(f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('{DATA_DIR}/{taxi_type}/*.parquet', union_by_name=true)
        """)

    # for taxi_type in ["yellow", "green"]:
    #     # We use 'union_by_name' to handle schema changes between months
    #     con.execute(f"""
    #         CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
    #         SELECT * FROM read_parquet('{DATA_DIR}/{taxi_type}/*.parquet', union_by_name=true)
    #     """)
    
    con.close()
    print("Ingestion complete!")