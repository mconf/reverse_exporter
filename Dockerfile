FROM golang:alpine AS build-env

RUN mkdir -p /go/src/github.com/wrouesnel/reverse_exporter
WORKDIR /go/src/github.com/wrouesnel/reverse_exporter
COPY . .

RUN GOOS=linux GOARCH=amd64 go run mage.go binary

FROM alpine:latest
RUN addgroup -S exporterg && adduser -S exporter -G exporterg
USER exporter
COPY --from=build-env /go/src/github.com/wrouesnel/reverse_exporter/bin/reverse_exporter_v0.0.0_linux-amd64/reverse_exporter /opt/reverse_exporter

ENTRYPOINT [ "/opt/reverse_exporter" ]
