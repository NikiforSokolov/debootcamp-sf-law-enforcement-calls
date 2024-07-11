import os
from connectors.airbyte import AirbyteClient
from assets.pipeline_logging import PipelineLogging
from dotenv import load_dotenv



if __name__ == "__main__":
    pipeline_logging = PipelineLogging(
        pipeline_name="airbyte_test", log_folder_path="logs"
    )
    pipeline_logging.logger.info("Starting Airbyte test")
    pipeline_logging.logger.info("Loading Environment Variables")   
    load_dotenv(override=True)
    AIRBYTE_USERNAME = os.environ.get("AIRBYTE_USERNAME")
    AIRBYTE_PASSWORD = os.environ.get("AIRBYTE_PASSWORD")
    AIRBYTE_SERVER_NAME = os.environ.get("AIRBYTE_SERVER_NAME")
    AIRBYTE_CONNECTION_ID = os.environ.get("AIRBYTE_CONNECTION_ID")

    pipeline_logging.logger.info("Validating Airbyte connection")
    airbyte_client = AirbyteClient(
        server_name=AIRBYTE_SERVER_NAME,
        username=AIRBYTE_USERNAME,
        password=AIRBYTE_PASSWORD
    )
    if airbyte_client.valid_connection():
            pipeline_logging.logger.info("Airbyte Running Extract and Load")
            airbyte_client.trigger_sync(
                connection_id=AIRBYTE_CONNECTION_ID
            )
            pipeline_logging.logger.info("Airbyte Extract and Load Complete")
    

    #print(pipeline_logging.get_logs())