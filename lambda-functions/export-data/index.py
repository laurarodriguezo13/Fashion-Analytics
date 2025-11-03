import json
import boto3
import os
import csv
from io import StringIO
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def lambda_handler(event, context):
    """
    Export data from DynamoDB tables to JSON format
    Query parameters:
    - table: Table to export ('trends', 'sales', 'sentiment')
    - format: Export format ('json' or 'csv') - default: 'json'
    """
    
    try:
        params = event.get('queryStringParameters') or {}
        table_type = params.get('table', 'trends')
        export_format = params.get('format', 'json')
        
        # Map table type to environment variable
        table_map = {
            'trends': os.environ.get('TRENDS_TABLE'),
            'sales': os.environ.get('SALES_TABLE'),
            'sentiment': os.environ.get('SENTIMENT_TABLE')
        }
        
        table_name = table_map.get(table_type)
        
        if not table_name:
            return {
                'statusCode': 400,
                'headers': {'Access-Control-Allow-Origin': '*'},
                'body': json.dumps({
                    'success': False,
                    'error': f'Invalid table type: {table_type}'
                })
            }
        
        print(f"Exporting data from table: {table_name}")
        
        # Scan table (in production, use pagination for large datasets)
        table = dynamodb.Table(table_name)
        response = table.scan(Limit=1000)
        items = response.get('Items', [])
        
        print(f"Found {len(items)} items to export")
        
        if export_format == 'csv' and items:
            # Convert to CSV
            csv_buffer = StringIO()
            writer = csv.DictWriter(csv_buffer, fieldnames=items[0].keys())
            writer.writeheader()
            for item in items:
                # Convert Decimal to float for CSV
                row = {k: (float(v) if isinstance(v, Decimal) else v) for k, v in item.items()}
                writer.writerow(row)
            
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'text/csv',
                    'Content-Disposition': f'attachment; filename="{table_type}_export.csv"'
                },
                'body': csv_buffer.getvalue()
            }
        else:
            # Return as JSON
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({
                    'success': True,
                    'table': table_type,
                    'count': len(items),
                    'data': items
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
