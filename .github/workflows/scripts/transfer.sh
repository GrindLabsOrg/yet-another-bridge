#!/bin/bash

# ANSI format
GREEN='\e[32m'
RESET='\e[0m'

DESTINATION_ADDRESS=0x70997970C51812dc3A010C7d01b50e0d17dc79C8
DESTINATION_ADDRESS_UINT=642829559307850963015472508762062935916233390536

echo -e "${GREEN}\n=> [SN] Making transfer to Destination account${COLOR_RESET}" # 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 -> 642829559307850963015472508762062935916233390536

MM_INITIAL_BALANCE=$(cast balance --rpc-url $ETH_RPC_URL --ether $MM_ETHEREUM_WALLET)
DESTINATION_INITIAL_BALANCE=$(cast balance --rpc-url $ETH_RPC_URL --ether $DESTINATION_ADDRESS)
echo "Initial MM balance: $MM_INITIAL_BALANCE"
echo "Initial Destination balance: $DESTINATION_INITIAL_BALANCE"

echo "Transferring $AMOUNT to $DESTINATION_ADDRESS"
cast send --rpc-url $ETH_RPC_URL --private-key $ETH_PRIVATE_KEY \
  $YAB_TRANSFER_PROXY_ADDRESS "transfer(uint256, uint256, uint256)" \
  "0" "$DESTINATION_ADDRESS_UINT" "$AMOUNT" \
  --value $AMOUNT >> /dev/null

MM_FINAL_BALANCE=$(cast balance --rpc-url $ETH_RPC_URL --ether $MM_ETHEREUM_WALLET)
DESTINATION_FINAL_BALANCE=$(cast balance --rpc-url $ETH_RPC_URL --ether $DESTINATION_ADDRESS)
echo "Final MM balance: $MM_FINAL_BALANCE"
echo "Final Destination balance: $DESTINATION_FINAL_BALANCE"