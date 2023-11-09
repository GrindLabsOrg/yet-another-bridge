import os

ETH_RPC_URL = 'https://goerli.nodeguardians.io'
SN_RPC_URL = 'https://goerli.infura.io/v3/'

ETH_CONTRACT_ADDR = '0x'
SN_CONTRACT_ADDR = '0x'

ETH_PRIVATE_KEY = os.getenv('ETH_PRIVATE_KEY')

HERODOTUS_API_KEY = os.getenv('HERODOTUS_API_KEY')
HERODOTUS_ORIGIN_CHAIN = '5'
HERODOTUS_DESTINATION_CHAIN = 'SN_GOERLI'

MAX_RETRIES = 30
RETRIES_DELAY = 30 # 30 seconds, 30 tries within 15 minutes
