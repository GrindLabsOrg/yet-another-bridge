#!/bin/bash
. contracts/utils/colors.sh #for ANSI colors

cd contracts/ethereum


printf "${GREEN}\n=> [ETH] Deploying ERC1967Proxy & PaymentRegistry ${COLOR_RESET}\n"

echo "Going in deploy.s.sol:\n"
pwd
RESULT_LOG=$(forge script ./test/ZKsync/deploy_paymentRegistry.s.sol --rpc-url http://localhost:8545 --broadcast)
# echo "$RESULT_LOG" #uncomment this line for debugging in detail

# Getting result addresses
PAYMENT_REGISTRY_PROXY_ADDRESS=$(echo "$RESULT_LOG" | grep -Eo '0: address ([^\n]+)' | awk '{print $NF}')
PAYMENT_REGISTRY_ADDRESS=$(echo "$RESULT_LOG" | grep -Eo '1: address ([^\n]+)' | awk '{print $NF}')

echo "$RESULT_LOG"

if [ -z "$PAYMENT_REGISTRY_PROXY_ADDRESS" ]; then
    printf "\n${RED}ERROR:${COLOR_RESET}\n"
    echo "PAYMENT_REGISTRY_PROXY_ADDRESS Variable is empty. Aborting execution.\n"
    exit 1
fi
if [ -z "$PAYMENT_REGISTRY_ADDRESS" ]; then
    printf "\n${RED}ERROR:${COLOR_RESET}\n"
    echo "PAYMENT_REGISTRY_ADDRESS Variable is empty. Aborting execution.\n"
    exit 1
fi

printf "${GREEN}\n=> [ETH] Deployed Proxy address: $PAYMENT_REGISTRY_PROXY_ADDRESS ${COLOR_RESET}\n"
printf "${GREEN}\n=> [ETH] Deployed PaymentRegistry address: $PAYMENT_REGISTRY_ADDRESS ${COLOR_RESET}\n"

echo "\nIf you now wish to deploy SN Escrow, you will need to run the following commands:"
echo "export PAYMENT_REGISTRY_PROXY_ADDRESS=$PAYMENT_REGISTRY_PROXY_ADDRESS"
echo "make starknet-deploy"

cd ../.. #to reset working directory