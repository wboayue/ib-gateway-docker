# Interactive Brokers Gateway Docker

Runs the Interactive Brokers Gateway in a docker container.

The image contains the following components.

* [IB Gateway Application](https://www.interactivebrokers.com/en/index.php?f=16457)
* [IBC Application](https://github.com/IbcAlpha/IBC) - enables automated launch of the IB Gateway Application.
* [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) -
a X11 virtual framebuffer to run IB Gateway Application without graphics hardware.
* [x11vnc](https://wiki.archlinux.org/title/x11vnc) -
a VNC server that allows to interact with the IB Gateway user interface 

# Usage

The simplest way to use the container is with the prebuilt image.

Given that Interactive Broker credentials are defined in a file named `credentials.env`. The gateway can be launched using the following commands.

The following command will launch the gateway in **live mode**.

```bash
docker run --env-file credentials.env -p 5900:5900 -p 4001:4001 wboayue/ib-gateway:latest
```

The following command will launch the gateway in **paper mode**.

```bash
docker run --env-file credentials.env -e TRADING_MODE=paper -p 5900:5900 -p 4002:4002 wboayue/ib-gateway:latest
```

When the container successfully launches the interactive broker gateway runs on port 4001 for live mode and port 4002 for paper mode.
The VNC server runs on port 5900. It is assumed that the container runs on a secure network.The VNC server does not require a password.

Credentials are specified in `credentials.env` using the following format.

```text
IB_LOGIN=<ib login>
IB_PASSWORD=<ib password>
```

The image with the tag latest is built with Interactive Brokers Gateway version 10.20 and IBC version 3.16.0.

If the container needs to be customized, source is located at [wboayue/ibc-gateway-docker](https://github.com/wboayue/ib-gateway-docker)

# Development

## Build container

```bash
docker build -t ib-gateway:latest .
```

## Run Gateway

```bash
docker run --env-file ib-paper.env -p 5900:5900 -p 4002:4002 ib-gateway
```

```bash
docker run --env-file ib-live.env -p 5900:5900 -p 4001:4001 ib-gateway
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
