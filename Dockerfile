FROM alpine:latest

RUN apk --no-cache add vlc

RUN adduser -h /vlc -g "VLC User" -s /sbin/nologin -D vlc vlc

WORKDIR /vlc

COPY --chown=vlc:vlc ./start.sh ./

USER vlc

ENTRYPOINT ./start.sh
