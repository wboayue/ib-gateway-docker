#!/bin/bash
set -eux

if [[ -z "${IB_LOGIN}" ]]; then
    echo "Environment variable IB_LOGIN is required. It specifies the TWS username." 
    exit 1
fi

if [[ -z "${IB_PASSWORD}" ]]; then
    echo "Environment variable IB_PASSWORD is required. It specifies the TWS password." 
    exit 1
fi

TRADING_MODE="${TRADING_MODE:-live}"

IBC_INI=$IBC_PATH/config.ini

# Configure startup script
mkdir -p ~/ibc
sed -e "s/IbLoginId=edemo/IbLoginId=${IB_LOGIN}/;s/IbPassword=demouser/IbPassword=${IB_PASSWORD}/;s/TradingMode=live/TradingMode=${TRADING_MODE}/" > ~/ibc/config.ini

Xvfb ${DISPLAY} -ac -screen 0 1024x768x16 &

#  -passwd "$VNC_SERVER_PASSWORD"
x11vnc -ncache_cr -display ${DISPLAY} -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6

# sleep 30

# if [ "$TRADING_MODE" = "paper" ]; then
#   printf "Forking :::4000 onto 0.0.0.0:4002\n"
#   socat TCP-LISTEN:4002,fork TCP:127.0.0.1:4000
# else
#   printf "Forking :::4000 onto 0.0.0.0:4001\n"
#   socat TCP-LISTEN:4001,fork TCP:127.0.0.1:4000
# fi

sed --in-place=.bak -e "s/TWS_MAJOR_VRSN=1019/TWS_MAJOR_VRSN=${TWS_MAJOR_VRSN}/" /opt/ibc/gatewaystart.sh
cat /opt/ibc/gatewaystart.sh

mkdir -p /root/ibc/logs/
touch /root/ibc/logs/ibc-3.16.0_GATEWAY-1020_Saturday.txt
tail -f /root/ibc/logs/ibc-3.16.0_GATEWAY-1020_Saturday.txt &

/opt/ibc/gatewaystart.sh -inline

