#!/usr/bin/env python3
"""
Populate DynamoDB tables with sample fashion analytics data
"""

import boto3
import csv
import sys
from decimal import Decimal

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

def load_csv(filename):
    """Load CSV file and return list of dictionaries"""
    data = []
    with open(filename, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            data.append(row)
    return data

def convert_to_decimal(value):
    """Convert numeric strings to Decimal for DynamoDB"""
    try:
        return Decimal(str(value))
    except:
        return value

def populate_trends_table(table_name):
    """Populate Fashion Trends table"""
    print(f"\n📊 Populating {table_name}...")
    
    table = dynamodb.Table(table_name)
    data = load_csv('../data/sample-data/trends.csv')
    
    count = 0
    for item in data:
        # Convert numeric fields to Decimal
        item['popularity_score'] = convert_to_decimal(item['popularity_score'])
        item['growth_rate'] = convert_to_decimal(item['growth_rate'])
        
        table.put_item(Item=item)
        count += 1
        print(f"  ✓ Added: {item['category']} - {item['trend_name']}")
    
    print(f"✅ Added {count} trends to {table_name}")

def populate_sales_table(table_name):
    """Populate Sales Analytics table"""
    print(f"\n💰 Populating {table_name}...")
    
    table = dynamodb.Table(table_name)
    data = load_csv('../data/sample-data/sales.csv')
    
    count = 0
    for item in data:
        # Convert numeric fields to Decimal
        item['revenue'] = convert_to_decimal(item['revenue'])
        item['units_sold'] = convert_to_decimal(item['units_sold'])
        item['avg_price'] = convert_to_decimal(item['avg_price'])
        item['gross_margin'] = convert_to_decimal(item['gross_margin'])
        item['return_rate'] = convert_to_decimal(item['return_rate'])
        
        table.put_item(Item=item)
        count += 1
        print(f"  ✓ Added: {item['brand']} - {item['month']}")
    
    print(f"✅ Added {count} sales records to {table_name}")

def populate_sentiment_table(table_name):
    """Populate Brand Sentiment table"""
    print(f"\n💬 Populating {table_name}...")
    
    table = dynamodb.Table(table_name)
    data = load_csv('../data/sample-data/sentiment.csv')
    
    count = 0
    for item in data:
        # Convert numeric fields to Decimal
        item['sentiment_score'] = convert_to_decimal(item['sentiment_score'])
        item['mention_count'] = convert_to_decimal(item['mention_count'])
        item['positive_mentions'] = convert_to_decimal(item['positive_mentions'])
        item['negative_mentions'] = convert_to_decimal(item['negative_mentions'])
        item['neutral_mentions'] = convert_to_decimal(item['neutral_mentions'])
        
        table.put_item(Item=item)
        count += 1
        print(f"  ✓ Added: {item['brand']} - {item['date']}")
    
    print(f"✅ Added {count} sentiment records to {table_name}")

def main():
    """Main function"""
    print("🚀 Starting DynamoDB population...")
    print("=" * 60)
    
    # Table names (update if different)
    trends_table = 'fashion-analytics-dev-trends'
    sales_table = 'fashion-analytics-dev-sales-analytics'
    sentiment_table = 'fashion-analytics-dev-sentiment'
    
    try:
        # Populate tables
        populate_trends_table(trends_table)
        populate_sales_table(sales_table)
        populate_sentiment_table(sentiment_table)
        
        print("\n" + "=" * 60)
        print("🎉 Successfully populated all DynamoDB tables!")
        print("=" * 60)
        
        # Summary
        print("\n📈 Summary:")
        print(f"  • Trends table: {trends_table}")
        print(f"  • Sales table: {sales_table}")
        print(f"  • Sentiment table: {sentiment_table}")
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        sys.exit(1)

if __name__ == '__main__':
    main()
