FROM alpine:latest
WORKDIR /app/build
COPY . /app
RUN apk add --no-cache g++ make cmake libmpdclient-dev openssl-dev
RUN cmake ..
RUN make

FROM alpine:latest
RUN apk add  --no-cache libmpdclient openssl
EXPOSE 8080
COPY --from=0 /app/build/ympd /usr/bin/ympd
COPY --from=0 /app/build/mkdata /usr/bin/mkdata
CMD ympd -h $MPD_SERVER -p $MPD_PORT
