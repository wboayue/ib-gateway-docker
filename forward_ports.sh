#!/bin/bash

sleep 5

if [ "$TRADING_MODE" = "paper" ]; then
  printf "\nForwarding 0.0.0.0:4002 -> :::4000\n\n"
  socat TCP-LISTEN:4002,fork TCP:127.0.0.1:4000
else
  printf "\nForwarding 0.0.0.0:4001 -> :::4000\n\n"
  socat TCP-LISTEN:4001,fork TCP:127.0.0.1:4000
fi
