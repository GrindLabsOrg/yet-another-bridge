#!/bin/bash

# ANSI format
GREEN='\e[32m'
COLOR_RESET='\033[0m'


echo "${GREEN}\n=> [ETH] Setting Starknet Escrow Address on ETH Smart Contract${COLOR_RESET}"

echo "Smart contract being modified:" $YAB_TRANSFER_PROXY_ADDRESS
echo "New Escrow address:" $ESCROW_CONTRACT_ADDRESS

cast send --rpc-url $ETH_RPC_URL --private-key $ETH_PRIVATE_KEY $YAB_TRANSFER_PROXY_ADDRESS "setEscrowAddress(uint256)" $ESCROW_CONTRACT_ADDRESS | grep "transactionHash"
