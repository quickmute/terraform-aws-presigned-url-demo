import boto3
import botocore
import json
import os
import base64
import time
from botocore.client import Config

from datetime import datetime
from datetime import datetime

def presigned_url(s3_client, objectname,expiration=3600):
    bucket_name = os.environ.get('bucket',None)
    if (bucket_name is not None):
        fullObjectName = "/".join(["temp",objectname])
        ##this content type must match
        ##ContentType: 'application/x-www-form-urlencoded; charset=UTF-8' 
        print(bucket_name)
        print(fullObjectName)
        '''
        FIELDS:
            acl, Cache-Control, Content-Type, 
            Content-Disposition, Content-Encoding, 
            Expires, success_action_redirect, redirect, 
            success_action_status, and x-amz-meta-
        '''
        fields = {
            "acl" : "bucket-owner-full-control",
            "Content-Type" : "text/plain"
        }
        conditions = [
            {
                "acl": "bucket-owner-full-control"
            }
        ]
        '''
        :param fields: Dictionary of prefilled form fields
        :param conditions: List of conditions to include in the policy
        :return: Dictionary with the following keys:
            url: URL to post to
            fields: Dictionary of form fields and values to submit with the POST
        '''
        try:
            response = s3_client.generate_presigned_post(   bucket_name,
                                                            fullObjectName,
                                                            Fields = fields,
                                                            Conditions = conditions,
                                                            ExpiresIn = expiration)
        except botocore.exceptions.ClientError as error:
            print(error)
            return None
    else:
        print('No Bucket Specified')
        return None
    return response

def lambda_handler(event, context):
    lambda_location = os.environ.get('LAMBDA_TASK_ROOT','local')
    region = os.environ.get('AWS_REGION','us-east-1')
    if(lambda_location == 'local'):
        profile = 'default'
        session = boto3.Session(profile_name=profile)
        print('in local')
    else:
        session = boto3
        print('in lambda')
    # Need to force s3 to use signature version 4 for consistency. Some S3 region may not default to v4 at this time and your return fields will be different. 
    s3Client = session.client("s3",config=Config(signature_version='s3v4'), region_name = region)
    body = event.get('body',None)
    if (body is not None):
        requestBody = json.loads(body)
        argument = requestBody.get('argument', None)    
    else:
        argument = None
        
    if(argument is not None):
        print('argument=',argument)
        result = presigned_url(s3Client, argument, expiration=60)
        print('result=',result)
        resultInJson = json.dumps(result)
        statusCode = 200
    else:
        print('Argument missing')
        result = "none"
        statusCode = 500

    return {
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'statusCode': statusCode,
        'body': json.dumps({
            'Response': resultInJson}
            )
    }
