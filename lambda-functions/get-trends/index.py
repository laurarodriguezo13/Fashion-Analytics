import json
import boto3
import os
from boto3.dynamodb.conditions import Key
from decimal import Decimal

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TRENDS_TABLE']
table = dynamodb.Table(table_name)

# Helper to convert Decimal to float/int for JSON serialization
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def lambda_handler(event, context):
    """
    Get fashion trends by category
    Query parameters:
    - category: Category to filter by (e.g., 'Dresses', 'Footwear')
    - limit: Number of results to return (default: 10)
    """
    
    try:
        # Extract query parameters
        params = event.get('queryStringParameters') or {}
        category = params.get('category', 'Dresses')
        limit = int(params.get('limit', 10))
        
        print(f"Querying trends for category: {category}, limit: {limit}")
        
        # Query DynamoDB
        response = table.query(
            KeyConditionExpression=Key('category').eq(category),
            ScanIndexForward=False,  # Sort descending by date
            Limit=limit
        )
        
        items = response.get('Items', [])
        
        print(f"Found {len(items)} trends")
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'GET, OPTIONS',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'success': True,
                'category': category,
                'count': len(items),
                'trends': items
            }, default=decimal_default)
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }
