import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DDB_TABLE_NAME'])

def lambda_handler(event, context):
    event_type = event.get('eventType')

    if event_type in [3, 8]:
        item = {
            'id': event['payload']['id'],
            'type': event_type,
            'data': event['payload']['data']
        }

        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': f"Event {event_type} logged successfully"
        }
    else:
        return {
            'statusCode': 204,
            'body': "Event ignored"
        }
