# Build the cipher service binary
FROM golang:1.12.7-stretch as base

# add the working directory for the project
WORKDIR /go/src/petstore

# just an indication that this port will be exposed by this container
EXPOSE 3333

# Copy the service code
COPY internal internal
COPY pkg pkg
COPY vendor vendor
COPY main.go main.go
COPY go.mod go.mod
COPY go.sum go.sum

# building service binary at path petstore/www
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOFLAGS=-mod=vendor go build -o www

## Using the multi-stage image to just run the binary
FROM alpine:latest as final

# Init working directory to root /
WORKDIR /

# Copy just the binary from the base image
COPY --from=base /go/src/petstore/www .

# command to run at the immediate start of the container
ENTRYPOINT ["./www"]
