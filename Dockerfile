FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    DISABLE_SYSLOG=0 \
    DISABLE_SSH=1 \
    DISABLE_CRON=1

LABEL maintainer="Wil Boayue <wil.boayue@gmail.com>"

RUN apt-get update \
    && apt-get install -y unzip xvfb x11vnc default-jre metacity openjfx \
    && apt-get clean

WORKDIR /root

# Install IB Gateway
COPY vendor/ibgateway-1020-standalone-linux-x64.sh ibgateway-1020-standalone-linux-x64.sh
RUN chmod a+x ibgateway-1020-standalone-linux-x64.sh \
    && echo "\nn" | sh ./ibgateway-1020-standalone-linux-x64.sh \
    && rm ibgateway-1020-standalone-linux-x64.sh

# Install IBC
COPY vendor/IBCLinux-3.16.0.zip IBCLinux-3.16.0.zip
RUN unzip IBCLinux-3.16.0.zip -d /opt/ibc \
    && chmod +x /opt/ibc/*.sh /opt/ibc/scripts/*.sh \
    && rm IBCLinux-3.16.0.zip
COPY config.ini.tmpl /opt/ibc/config.ini

ENV IBC_PATH=/opt/ibc \
    TWS_MAJOR_VRSN=1020 \
    TWS_PATH=/root/Jts \
    DISPLAY=:0 \
    TZ=America/New_York

COPY launch_gateway.sh launch_gateway.sh

CMD ./launch_gateway.sh
