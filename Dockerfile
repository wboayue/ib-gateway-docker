FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    DISABLE_SYSLOG=0 \
    DISABLE_SSH=1 \
    DISABLE_CRON=1 \
    DISPLAY=:0 \
    TZ=America/New_York

LABEL maintainer="Wil Boayue <wil.boayue@gmail.com>"

RUN apt-get update && apt-get install -y \
      unzip \
      xvfb \
      x11vnc \
      default-jre \
      metacity \
      openjfx && apt-get clean

WORKDIR /root

# Install IB Gateway

COPY vendor/ibgateway-latest-standalone-linux-x64.sh ibgateway-latest-standalone-linux-x64.sh

RUN chmod a+x ibgateway-latest-standalone-linux-x64.sh \
    && echo "\nn" | ./ibgateway-latest-standalone-linux-x64.sh -c \
    && rm ibgateway-latest-standalone-linux-x64.sh

COPY vendor/IBCLinux-3.16.0.zip IBCLinux-3.16.0.zip

RUN unzip IBCLinux-3.16.0.zip -d /opt/ibc && chmod +x /opt/ibc/*.sh /opt/ibc/scripts/*.sh

ENV IBC_PATH=/opt/ibc \
    TWS_MAJOR_VRSN=972 \
    TWS_PATH=/root/Jts


