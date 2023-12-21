import os
from dotenv import load_dotenv

load_dotenv()

ENVIRONMENT = os.getenv('ENVIRONMENT')

ETH_RPC_URL = os.getenv('ETH_RPC_URL')
SN_RPC_URL = os.getenv('SN_RPC_URL')

ETH_FALLBACK_RPC_URL = os.getenv('ETH_FALLBACK_RPC_URL')
SN_FALLBACK_RPC_URL = os.getenv('SN_FALLBACK_RPC_URL')

ETH_CONTRACT_ADDR = os.getenv('ETH_CONTRACT_ADDR')
SN_CONTRACT_ADDR = os.getenv('SN_CONTRACT_ADDR')

ETH_PRIVATE_KEY = os.getenv('ETH_PRIVATE_KEY')
SN_WALLET_ADDR = os.getenv('SN_WALLET_ADDR')
SN_PRIVATE_KEY = os.getenv('SN_PRIVATE_KEY')

HERODOTUS_API_KEY = os.getenv('HERODOTUS_API_KEY')
HERODOTUS_ORIGIN_CHAIN = '5'
HERODOTUS_DESTINATION_CHAIN = 'SN_GOERLI'

MAX_RETRIES = 30
RETRIES_DELAY = 60  # 60 seconds, 30 tries within 30 minutes

POSTGRES_HOST = os.getenv('POSTGRES_HOST')
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_DB = os.getenv('POSTGRES_DB')

LOGGING_LEVEL = os.getenv('LOGGING_LEVEL')
LOGGING_DIR = os.getenv('LOGGING_DIR')
