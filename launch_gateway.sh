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

# Start VNC server. This allows desktop to be viewed.
#  -passwd "$VNC_SERVER_PASSWORD"
x11vnc -ncache_cr -display ${DISPLAY} -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6

# Configure and start IB Gateway

sed --in-place=.bak -e "s/TWS_MAJOR_VRSN=1019/TWS_MAJOR_VRSN=${TWS_MAJOR_VRSN}/" /opt/ibc/gatewaystart.sh
/opt/ibc/gatewaystart.sh -inline
