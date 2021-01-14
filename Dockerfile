FROM alpine:latest
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.source https://github.com/aperim/docker-vlc-multicast
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="VLC to Multicast" \
  org.label-schema.description="Reflect a stream to multicast" \
  org.label-schema.url="https://github.com/aperim/docker-vlc-multicast" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-vlc-multicast" \
  org.label-schema.vendor="Aperim Pty Ltd" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

RUN apk --no-cache add vlc

RUN adduser -h /vlc -g "VLC User" -s /sbin/nologin -D vlc vlc

WORKDIR /vlc

COPY --chown=vlc:vlc ./start.sh ./

USER vlc

ENTRYPOINT ./start.sh
