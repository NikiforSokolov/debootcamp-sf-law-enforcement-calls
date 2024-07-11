#!/bin/bash
# go the extract load directory and run airbyte
cd extract_load && 
python -m pipelines.airbyte_extract_load &&
# go to the transform directory and run dbt
cd .. &&
cd transform/warehouse &&
dbt deps &&
dbt build --target prod