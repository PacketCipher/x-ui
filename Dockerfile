FROM golang:latest AS builder
WORKDIR /root
COPY . .
RUN go build main.go


FROM debian:11-slim
LABEL org.opencontainers.image.authors="hossin.asaadi77@gmail.com"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends -y ca-certificates iproute2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV TZ=Asia/Shanghai
WORKDIR /root
COPY --from=builder  /root/main /root/x-ui
RUN mkdir bin && \
    cd bin && \
    wget https://github.com/PacketCipher/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    rm -f Xray-linux-64.zip geoip.dat geosite.dat && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && \
    mv xray xray-linux-amd64
VOLUME [ "/etc/x-ui" ]
CMD [ "./x-ui" ]
