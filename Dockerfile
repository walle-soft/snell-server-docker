
FROM tonistiigi/xx AS xx

FROM alpine as build

COPY --from=xx / /
COPY get_url.sh /get_url.sh


ENV VERSION 4.0.1


RUN xx-info env && wget -q -O "snell-server.zip" $(/get_url.sh ${VERSION} $(xx-info arch)) && \
    unzip snell-server.zip && rm snell-server.zip && \
    xx-verify /snell-server

FROM ubuntu:latest

ENV TZ=UTC

WORKDIR /

COPY --from=build /snell-server /usr/bin/snell-server

COPY start.sh /start.sh

EXPOSE 9102

CMD /start.sh
