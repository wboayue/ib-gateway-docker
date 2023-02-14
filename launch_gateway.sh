#!/bin/bash
#
# Launches the Interactive Brokers Gateway using IBC.
set -eu

function validate_arguments() {
    if [[ -z "${IB_LOGIN}" ]]; then
        echo "Environment variable IB_LOGIN is required. It specifies the TWS username." 
        exit 1
    fi

    if [[ -z "${IB_PASSWORD}" ]]; then
        echo "Environment variable IB_PASSWORD is required. It specifies the TWS password." 
        exit 1
    fi
}

function start_virtual_desktop() {
    Xvfb ${DISPLAY} -ac -screen 0 1024x768x16 &
}

function start_vnc_server() {
    x11vnc -ncache_cr -display ${DISPLAY} -forever -shared -logappend /var/log/x11vnc.log -bg -noipv6
}

function forward_ports() {
    sleep 5

    if [ "$TRADING_MODE" = "paper" ]; then
        printf "\nForwarding 0.0.0.0:4002 -> :::4000\n\n"
        socat TCP-LISTEN:4002,fork TCP:127.0.0.1:4000
    else
        printf "\nForwarding 0.0.0.0:4001 -> :::4000\n\n"
        socat TCP-LISTEN:4001,fork TCP:127.0.0.1:4000
    fi
}

function configure_ibc() {
    TRADING_MODE="${TRADING_MODE:-live}"

    mkdir -p ~/ibc

    sed -e "s/IbLoginId=edemo/IbLoginId=${IB_LOGIN}/;s/IbPassword=demouser/IbPassword=${IB_PASSWORD}/;s/TradingMode=live/TradingMode=${TRADING_MODE}/;s/OverrideTwsApiPort=/OverrideTwsApiPort=4000/;s/AcceptNonBrokerageAccountWarning=no/AcceptNonBrokerageAccountWarning=yes/" /opt/ibc/config.ini > ~/ibc/config.ini
    sed --in-place=.bak -e "s/TradingMode=live/TradingMode=${TRADING_MODE}/" ~/ibc/config.ini
    sed --in-place=.bak -e "s/OverrideTwsApiPort=/OverrideTwsApiPort=4000/" ~/ibc/config.ini
    sed --in-place=.bak -e "s/AcceptNonBrokerageAccountWarning=no/AcceptNonBrokerageAccountWarning=yes/" ~/ibc/config.ini

    sed --in-place=.bak -e "s/TWS_MAJOR_VRSN=1019/TWS_MAJOR_VRSN=${TWS_MAJOR_VRSN}/" /opt/ibc/gatewaystart.sh
}

function main() {
    validate_arguments

    start_virtual_desktop
    start_vnc_server

    forward_ports &

    configure_ibc
    /opt/ibc/gatewaystart.sh -inline
}

main "$@"
