#!/bin/bash

# ANSI format
GREEN='\e[32m'
COLOR_RESET='\033[0m'

cd "$(dirname "$0")"

if [ -f .env ]; then
    echo "Sourcing solidity/.env file..."
    source .env
else
    echo "Error: solidity/.env file not found!"
    exit 1
fi

echo -e "${GREEN}\n=> [ETH] Deploying ERC1967Proxy & YABTransfer ${COLOR_RESET}"
RESULT_LOG=$(forge script ./script/Deploy.s.sol --rpc-url $ETH_RPC_URL --broadcast --verify)
# echo "$RESULT_LOG" #uncomment this line for debugging in detail

# Getting result addresses
PROXY_ADDRESS=$(echo "$RESULT_LOG" | grep -oP '0: address \K[^\n]+' | awk '{print $0}')
YAB_TRANSFER_ADDRESS=$(echo "$RESULT_LOG" | grep -oP '1: address \K[^\n]+' | awk '{print $0}')

echo -e "${GREEN}\n=> [ETH] Deployed Proxy address: $PROXY_ADDRESS ${COLOR_RESET}"
echo -e "${GREEN}\n=> [ETH] Deployed YABTransfer address: $YAB_TRANSFER_ADDRESS ${COLOR_RESET}"

# Setting proxy_address into .env file
if grep -q "^YAB_TRANSFER_PROXY_ADDRESS=" ".env"; then
  sed -i "s/^YAB_TRANSFER_PROXY_ADDRESS=.*/YAB_TRANSFER_PROXY_ADDRESS=$PROXY_ADDRESS/" ".env"
else
  echo "YAB_TRANSFER_PROXY_ADDRESS=$PROXY_ADDRESS" >> ".env"
fi