# data-integration/lambda/stock_data_fetcher.py
import json
import os
import boto3
import requests
from datetime import datetime
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Get environment variables
BUCKET_NAME = os.environ['BUCKET_NAME']
TABLE_NAME = os.environ['TABLE_NAME']
API_KEY = os.environ['ALPHA_VANTAGE_API_KEY']
SYMBOLS = os.environ['STOCK_SYMBOLS'].split(',')  # e.g., "AAPL,MSFT,AMZN"

def lambda_handler(event, context):
    """
    Fetch stock data for specified symbols and store in S3 and DynamoDB
    """
    try:
        # Get current date for file naming
        current_date = datetime.now().strftime('%Y-%m-%d')
        
        # Process each stock symbol
        for symbol in SYMBOLS:
            logger.info(f"Processing symbol: {symbol}")
            
            # Fetch data from Alpha Vantage API
            stock_data = fetch_stock_data(symbol)
            
            if not stock_data:
                logger.error(f"Failed to fetch data for {symbol}")
                continue
                
            # Store raw data in S3
            s3_key = f"stock_data/{symbol}/{current_date}.json"
            store_in_s3(stock_data, s3_key)
            
            # Process and store in DynamoDB
            store_in_dynamodb(symbol, stock_data)
            
        return {
            'statusCode': 200,
            'body': json.dumps(f'Successfully processed {len(SYMBOLS)} symbols')
        }
    except Exception as e:
        logger.error(f"Error in lambda execution: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }

def fetch_stock_data(symbol):
    """
    Fetch daily stock data from Alpha Vantage API
    """
    try:
        url = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={symbol}&apikey={API_KEY}&outputsize=compact"
        response = requests.get(url)
        
        if response.status_code != 200:
            logger.error(f"API request failed with status code {response.status_code}")
            return None
            
        data = response.json()
        
        # Check if we got valid data
        if "Time Series (Daily)" not in data:
            logger.error(f"Invalid data format received: {data}")
            return None
            
        return data
    except Exception as e:
        logger.error(f"Error fetching stock data: {str(e)}")
        return None

def store_in_s3(data, s3_key):
    """
    Store JSON data in S3 bucket
    """
    try:
        s3_client.put_object(
            Bucket=BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(data),
            ContentType='application/json'
        )
        logger.info(f"Successfully stored data in S3: {s3_key}")
    except Exception as e:
        logger.error(f"Error storing data in S3: {str(e)}")
        raise

def store_in_dynamodb(symbol, stock_data):
    """
    Process and store relevant data points in DynamoDB
    """
    try:
        table = dynamodb.Table(TABLE_NAME)
        time_series = stock_data.get("Time Series (Daily)", {})
        
        # Get the latest data point (first item in time series)
        latest_date = list(time_series.keys())[0]
        latest_data = time_series[latest_date]
        
        # Prepare item for DynamoDB
        item = {
            'symbol': symbol,
            'date': latest_date,
            'open': float(latest_data.get('1. open', 0)),
            'high': float(latest_data.get('2. high', 0)),
            'low': float(latest_data.get('3. low', 0)),
            'close': float(latest_data.get('4. close', 0)),
            'volume': int(latest_data.get('5. volume', 0)),
            'timestamp': datetime.now().isoformat()
        }
        
        # Store in DynamoDB
        table.put_item(Item=item)
        logger.info(f"Successfully stored {symbol} data in DynamoDB")
    except Exception as e:
        logger.error(f"Error storing data in DynamoDB: {str(e)}")
        raise