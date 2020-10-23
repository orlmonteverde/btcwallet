FROM golang:1.15.3-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download

# Build app.
RUN CGO_ENABLED=0 go build -o /app/btcwallet .
RUN CGO_ENABLED=0 go build -o /app/dropwtxmgr /app/cmd/dropwtxmgr
RUN CGO_ENABLED=0 go build -o /app/sweepaccount /app/cmd/sweepaccount

FROM alpine:3.11.2
WORKDIR /bin
COPY --from=builder /app/btcwallet .
COPY --from=builder /app/dropwtxmgr .
COPY --from=builder /app/sweepaccount .

ENV USER=user
ENV PASSWORD=53cr37

# Default ports.
EXPOSE 18554
EXPOSE 18555
EXPOSE 18556

CMD [ "btcwallet", "--simnet", "-u", "${USER}", "-P", "${PASSWORD}"]
