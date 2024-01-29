#!/bin/bash

# ANSI format
GREEN='\e[32m'
PURPLE='\033[1;34m'
PINK='\033[1;35m'
ORANGE='\033[1;33m'
COLOR_RESET='\033[0m'

echo -e "${GREEN}\n=> [SN] Declaring Escrow${COLOR_RESET}"
ESCROW_CLASS_HASH=$(starkli declare \
  --account $STARKNET_ACCOUNT --keystore $STARKNET_KEYSTORE \
  --watch contracts/cairo/target/dev/yab_Escrow.contract_class.json)

echo -e "${GREEN}\n=> [SN] Escrow Declared${COLOR_RESET}"

echo -e "- ${PURPLE}[SN] Escrow ClassHash: $ESCROW_CLASS_HASH${COLOR_RESET}"
echo -e "- ${PURPLE}[SN] Market Maker SN Wallet: $MM_SN_WALLET_ADDR${COLOR_RESET}"
echo -e "- ${PURPLE}[SN] Ethereum ContractAddress $NATIVE_TOKEN_ETH_STARKNET${COLOR_RESET}" #why this print?
echo -e "- ${PINK}[ETH] YABTransfer Proxy Address: $YAB_TRANSFER_PROXY_ADDRESS${COLOR_RESET}"
echo -e "- ${PINK}[ETH] Market Maker ETH Wallet: $MM_ETHEREUM_WALLET${COLOR_RESET}"

echo -e "${GREEN}\n=> [SN] Deploying Escrow${COLOR_RESET}"
ESCROW_CONTRACT_ADDRESS=$(starkli deploy \
  --account $STARKNET_ACCOUNT --keystore $STARKNET_KEYSTORE \
  --watch $ESCROW_CLASS_HASH \
    $SN_ESCROW_OWNER \
    $YAB_TRANSFER_PROXY_ADDRESS \
    $MM_ETHEREUM_WALLET \
    $MM_SN_WALLET_ADDR \
    $NATIVE_TOKEN_ETH_STARKNET)

echo -e "${GREEN}\n=> [SN] Escrow Deployed${COLOR_RESET}"

echo -e "- ${PURPLE}[SN] Escrow Address: $ESCROW_CONTRACT_ADDRESS${COLOR_RESET}"

# if grep -q "^ESCROW_CONTRACT_ADDRESS=" ".env"; then
#   sed "s/^ESCROW_CONTRACT_ADDRESS=.*/ESCROW_CONTRACT_ADDRESS=$ESCROW_CONTRACT_ADDRESS/" .env >> env.temp.file
#   mv env.temp.file .env
# else
#   echo "ESCROW_CONTRACT_ADDRESS=$ESCROW_CONTRACT_ADDRESS" >> ".env"
# fi