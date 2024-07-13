#!/bin/bash
#go the extract load directory
cd extract_load && 
#run airbyte
python -m pipelines.airbyte_extract_load &&
#go to the transform directory 
cd .. &&
cd transform/warehouse &&
#run dbt
dbt deps &&
dbt build --target prod