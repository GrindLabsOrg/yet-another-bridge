#!/bin/bash

. contracts/utils/colors.sh #for ANSI colors

echo "Asserting values"
FAILED=false

assert() {
  #Usage: assert <variable_name> <obtained> <expected>
  if [ $2 = $3 ] ; then
    printf "${GREEN}✓ $1 passed.${RESET}\n"
  else
    printf "${RED}x $1 assertion failed: Obtained value: $2, Expected value: $3.${RESET}\n"
    FAILED=true
  fi
}

# #setorder
# echo setOrder
# assert BALANCE_USER_L2_BEFORE_SETORDER $BALANCE_USER_L2_BEFORE_SETORDER 1000000000000002977607000000000 #
# assert BALANCE_ESCROW_L2_BEFORE_SETORDER $BALANCE_ESCROW_L2_BEFORE_SETORDER 0
# assert BALANCE_USER_L2_AFTER_SETORDER $BALANCE_USER_L2_AFTER_SETORDER 999999999998002930766250000000 #
# assert BALANCE_ESCROW_L2_AFTER_SETORDER $BALANCE_ESCROW_L2_AFTER_SETORDER 2000000000000000000

# #transfer
# echo transfer
# assert BALANCE_MM_L1_BEFORE_TRANSFER $BALANCE_MM_L1_BEFORE_TRANSFER 99999998999999999999987225321481493064 #
# assert BALANCE_USER_L1_BEFORE_TRANSFER $BALANCE_USER_L1_BEFORE_TRANSFER 0
# assert BALANCE_MM_L1_AFTER_TRANSFER $BALANCE_MM_L1_AFTER_TRANSFER 99999998999999999997997047827481493064 #
# assert BALANCE_USER_L1_AFTER_TRANSFER $BALANCE_USER_L1_AFTER_TRANSFER 1990000000000000000

# #claimpeyment
# echo claimPayment
# assert BALANCE_MM_L1_BEFORE_CLAIMPAYMENT $BALANCE_MM_L1_BEFORE_CLAIMPAYMENT $BALANCE_MM_L1_AFTER_TRANSFER
# assert BALANCE_MM_L2_BEFORE_CLAIMPAYMENT $BALANCE_MM_L2_BEFORE_CLAIMPAYMENT 100000000000000268251975 #not yet updated
# assert BALANCE_ESCROW_L2_BEFORE_CLAIMPAYMENT $BALANCE_ESCROW_L2_BEFORE_CLAIMPAYMENT 2
# assert BALANCE_MM_L1_AFTER_CLAIMPAYMENT $BALANCE_MM_L1_AFTER_CLAIMPAYMENT 99999998999999999993004619721479929257 #
# assert BALANCE_MM_L2_AFTER_CLAIMPAYMENT $BALANCE_MM_L2_AFTER_CLAIMPAYMENT 100000000000700216110175 #
# assert BALANCE_MM_L2_CHANGE_CLAIMPAYMENT $(($BALANCE_MM_L2_AFTER_CLAIMPAYMENT-$BALANCE_MM_L2_BEFORE_CLAIMPAYMENT)) 2000000000
# assert BALANCE_ESCROW_L2_AFTER_CLAIMPAYMENT $BALANCE_ESCROW_L2_AFTER_CLAIMPAYMENT 0


#solo hace falta validar:
echo "solo hace falta validar:"

assert BALANCE_ESCROW_L2_AFTER_SETORDER $BALANCE_ESCROW_L2_AFTER_SETORDER 2000000000000000000
assert BALANCE_ESCROW_L2_AFTER_CLAIMPAYMENT $BALANCE_ESCROW_L2_AFTER_CLAIMPAYMENT 0

assert BALANCE_USER_L1_BEFORE_TRANSFER $BALANCE_USER_L1_BEFORE_TRANSFER 0
assert BALANCE_USER_L1_AFTER_TRANSFER $BALANCE_USER_L1_AFTER_TRANSFER 1990000000000000000

assert BALANCE_MM_L2_AFTER_CLAIMPAYMENT $BALANCE_MM_L2_AFTER_CLAIMPAYMENT 1000000000002102977607000000000 #

if $FAILED; then
  exit 1
fi
