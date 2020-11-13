FROM alpine:latest
WORKDIR /app/build
COPY . /app
RUN apk add --no-cache g++ make cmake libmpdclient-dev openssl-dev
RUN cmake ..
RUN make

FROM alpine:latest
RUN apk add  --no-cache libmpdclient openssl
COPY --from=0 /app/build/ympd /usr/bin/ympd
COPY --from=0 /app/build/mkdata /usr/bin/mkdata
ENV MPD_SERVER=localhost
ENV MPD_PORT=6600
ENV WEBPORT=8080
EXPOSE 8080/tcp
CMD ympd -h $MPD_SERVER -p $MPD_PORT
