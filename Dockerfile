FROM alpine:3.12
WORKDIR /src
RUN apk add --no-cache g++ make cmake libmpdclient-dev openssl-dev unzip
ADD https://github.com/notandy/ympd/archive/master.zip master.zip
RUN unzip master.zip -d /src/
RUN cmake /src/ympd-master/
RUN make

FROM alpine:3.12
RUN apk add  --no-cache libmpdclient openssl
COPY --from=0 /src/ympd /usr/bin/ympd
COPY --from=0 /src/mkdata /usr/bin/mkdata
ENV MPD_SERVER=0.0.0.0
ENV MPD_PORT=6600
ENV WEBPORT=8080
EXPOSE 8080/tcp
CMD ympd -h $MPD_SERVER -p $MPD_PORT
