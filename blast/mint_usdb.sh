#!/bin/bash

PRIV_KEY=1d594415d5a8e46e1639031173deb51d09860bf957bfbdcc52260f0ef08c5f10
ADDR=0xD98Ea43293Df9205C570FD071cE42a7b69b19919

cast send --rpc-url=https://rpc.sepolia.org \
  --private-key=$PRIV_KEY \
  0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
  "mint(address,uint256)" $ADDR 1000000000000000000000


cast send --rpc-url=https://rpc.sepolia.org \
  --private-key=$PRIV_KEY \
  0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 \
  "approve(address,uint256)" "0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8" 100000000000000000000000000





