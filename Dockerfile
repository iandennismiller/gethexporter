FROM golang:1.22-alpine as base
RUN apk add --no-cache git ca-certificates

WORKDIR /go/src/github.com/iandennismiller
RUN git clone https://github.com/iandennismiller/gethexporter.git
WORKDIR /go/src/github.com/iandennismiller/gethexporter
RUN go mod download
RUN go build -o /go/bin/gethexporter

FROM alpine:latest

RUN apk add --no-cache jq ca-certificates
COPY --from=base /go/bin/gethexporter /usr/local/bin/gethexporter

ENV GETH http://geth.lan:8545
ENV LISTEN "0.0.0.0:9090"
ENV ADDRESSES ""
ENV DELAY 500

EXPOSE 9090
ENTRYPOINT gethexporter
