#!/bin/bash
set -eu

if [[ -z "${IB_LOGIN}" ]]; then
    echo "Environment variable IB_LOGIN is required. It specifies the TWS username." 
    exit 1
fi

if [[ -z "${IB_PASSWORD}" ]]; then
    echo "Environment variable IB_PASSWORD is required. It specifies the TWS password." 
    exit 1
fi

# Starts a virtual desktop.

Xvfb ${DISPLAY} -ac -screen 0 1024x768x16 &

# Starts VNC server so virtual desktop can be viewed.

x11vnc -ncache_cr -display ${DISPLAY} -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6

# Configures and starts IB Gateway using IBC.

TRADING_MODE="${TRADING_MODE:-live}"
IBC_INI=$IBC_PATH/config.ini

# Relay port so connection appears from localhost to IB gateway

/root/forward_ports.sh &

mkdir -p ~/ibc

sed -e "s/IbLoginId=edemo/IbLoginId=${IB_LOGIN}/;s/IbPassword=demouser/IbPassword=${IB_PASSWORD}/;s/TradingMode=live/TradingMode=${TRADING_MODE}/;s/OverrideTwsApiPort=/OverrideTwsApiPort=4000/;s/AcceptNonBrokerageAccountWarning=no/AcceptNonBrokerageAccountWarning=yes/" /opt/ibc/config.ini > ~/ibc/config.ini
sed --in-place=.bak -e "s/TWS_MAJOR_VRSN=1019/TWS_MAJOR_VRSN=${TWS_MAJOR_VRSN}/" /opt/ibc/gatewaystart.sh

/opt/ibc/gatewaystart.sh -inline
