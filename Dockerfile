# build stage
FROM golang:alpine AS build-env
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
    git gcc libc-dev;
ENV GO111MODULE on
# Set the GOPROXY environment variable
ENV GOPROXY https://goproxy.io
WORKDIR /go/src/github.com/gothinkster/golang-gin-realworld-example-app
ADD go.mod go.sum ./
RUN go mod download
COPY . /go/src/github.com/gothinkster/golang-gin-realworld-example-app
RUN go build

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/gothinkster/golang-gin-realworld-example-app/golang-gin-realworld-example-app /app/golang-app
USER golang
EXPOSE 8080
ENTRYPOINT ./golang-app
