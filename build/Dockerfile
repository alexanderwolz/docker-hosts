FROM alpine:3.14.1

RUN apk add --no-cache bash docker-cli

WORKDIR /root

COPY ["common.sh", "hosts.sh", "./"]

CMD bash hosts.sh