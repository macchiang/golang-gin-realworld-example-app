# build stage
FROM golang:alpine AS build-env
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
    git gcc libc-dev; \
    go get -u github.com/kardianos/govendor; \
    go get -u github.com/pilu/fresh; \
    go get -u golang.org/x/crypto/... ;
# apk del .build-deps;
ADD ./vendor /go/src/github.com/wangzitian0/golang-gin-starter-kit/vendor
ENV GOPATH /go
ENV GOROOT /usr/local/go
WORKDIR /go/src/github.com/wangzitian0/golang-gin-starter-kit
RUN govendor sync;
RUN govendor add +external
COPY . /go/src/github.com/wangzitian0/golang-gin-starter-kit
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="-extldflags -static -s -w" -a -installsuffix cgo

# final stage
FROM gcr.io/distroless/base 
WORKDIR /app
COPY --from=build-env /go/src/github.com/wangzitian0/golang-gin-starter-kit/golang-gin-starter-kit /app/
EXPOSE 8080
ENTRYPOINT ["./golang-gin-starter-kit"]
