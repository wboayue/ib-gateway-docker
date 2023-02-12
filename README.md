# Runs the Interactive Brokers Gateway 

Runs the interactive brokers gateway in a docker container. 
Automates authentication using IBC and starts VNC server so desktop may be viewed using a VNC client.

This container could be useful setting up an automated trading system using Interactive Brokers as your broker.

The following projects were used as references [paulrosinger/ibc-docker](https://github.com/paulrosinger/ibc-docker), [waytrade/ib-gateway-docker](https://github.com/waytrade/ib-gateway-docker) and [UnusualAlpha/ib-gateway-docker](https://github.com/UnusualAlpha/ib-gateway-docker)

# Build container

Gateway downloads here
https://www.interactivebrokers.com/en/trading/ib-gateway-download.php

```bash
docker build -t ib-gateway:latest .
```

## Run Gateway

```bash
docker run --env-file ib-paper.env -p 5900:5900 -p 4002:4002 ib-gateway
```

```bash
docker run --env-file ib-live.env -p 5900:5900 -p 4002:4002 ib-gateway
```

## Configuration

```bash
IB_LOGIN=<ib login>
IB_PASSWORD=<ib password>
TRADING_MODE=[live|paper]
```

## Exposed Services

The container runs the following services.

| Service     | Port | Description                                 |
| ----------- | -----| ------------------------------------------- |
| VNC Viewer  | 5900 | Enables viewing of desktop with VNC client. |
| IB Gateway  | 4001 | IB Gateway when launched in paper mode.     |
| IB Gateway  | 4002 | IB Gateway when launched in live mode.      |

## Publish Container

Follow these steps to publish the container to Docker Hub.

```bash
docker login

docker build -t ib-gateway:latest .

docker tag ib-gateway:latest [username]/ib-gateway:latest
docker tag ib-gateway:latest [username]/ib-gateway:[gateway version]

docker push [username]/ib-gateway:latest
docker push [username]/ib-gateway:[gateway version]
```
