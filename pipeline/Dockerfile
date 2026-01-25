FROM python:3.13.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# RUN pip install pandas pyarrow

WORKDIR /app
# WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"

COPY "pyproject.toml" "uv.lock" ".python-version" ./

RUN uv sync --locked

#1st name is source filsle and 2nd is destination
# COPY pipeline.py pipeline.py
COPY ingest_data.py ingest_data.py

ENTRYPOINT ["python", "ingest_data.py"]