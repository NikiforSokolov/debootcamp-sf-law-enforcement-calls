FROM ghcr.io/dbt-labs/dbt-snowflake:1.7.1

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash", "orchestraitor.sh"]
