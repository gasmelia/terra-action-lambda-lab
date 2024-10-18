# create lambda function
import json
import boto3                    
import os
import logging                                                                                                               
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info("Event: " + json.dumps(event))
    logger.info("Context: " + json.dumps(context))   

    try:
        client = boto3.client('lambda')
        response = client.invoke(FunctionName=os.environ['function_name'], Payload=json.dumps(event))
        logger.info("Response: " + json.dumps(response))
    except ClientError as e:
        logger.error(e)
        raise e     
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

    