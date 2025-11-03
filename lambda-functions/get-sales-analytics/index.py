import json
import boto3
import os
from boto3.dynamodb.conditions import Key
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['SALES_TABLE']
table = dynamodb.Table(table_name)

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def lambda_handler(event, context):
    """
    Get sales analytics by brand
    Query parameters:
    - brand: Brand name to filter by (e.g., 'Nike', 'Zara')
    - limit: Number of months to return (default: 12)
    """
    
    try:
        params = event.get('queryStringParameters') or {}
        brand = params.get('brand', 'Nike')
        limit = int(params.get('limit', 12))
        
        print(f"Querying sales for brand: {brand}, limit: {limit}")
        
        # Query DynamoDB
        response = table.query(
            KeyConditionExpression=Key('brand').eq(brand),
            ScanIndexForward=False,  # Most recent first
            Limit=limit
        )
        
        items = response.get('Items', [])
        
        print(f"Found {len(items)} sales records")
        
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
                'brand': brand,
                'count': len(items),
                'analytics': items
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
