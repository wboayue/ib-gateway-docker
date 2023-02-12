# ib-gateway-docker

https://github.com/paulrosinger/ibc-docker/blob/master/Dockerfile

https://github.com/waytrade/ib-gateway-docker
https://github.com/UnusualAlpha/ib-gateway-docker

Gateway downloads here

https://www.interactivebrokers.com/en/trading/ib-gateway-download.php

docker build -t ib-gateway:latest .

docker run -e IB_LOGIN=edemo -e IB_PASSWORD=demouser ib-gateway