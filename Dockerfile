FROM golang:1.18.1-alpine AS builder
RUN mkdir /build
ADD go.mod go.sum main.go /build/
WORKDIR /build
RUN go build

FROM alpine
RUN adduser -S -D -H -h /app appuser
USER appuser
COPY --from=builder /build/api /app/
WORKDIR /app
EXPOSE 8080
CMD ["./api"]
