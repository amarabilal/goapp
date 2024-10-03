FROM alpine:latest AS git

FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY --from=git /mygoapp ./
RUN go mod init mygoapp
RUN go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -a -installsuffix cgo -o myapp .

FROM scratch
COPY --from=builder /app/myapp /myapp
WORKDIR /app
EXPOSE 8080
CMD [ "/myapp" ]
