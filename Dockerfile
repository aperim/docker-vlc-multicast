FROM alpine:latest
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG PORT=4212
ARG RC_PORT=5212
ENV PORT=${PORT}
ENV VLC_RC_PORT=${RC_PORT}

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

EXPOSE ${PORT}

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories && \
  apk --no-cache add vlc ffmpeg mpg123

# RUN apk --no-cache add vlc ffmpeg mpg123

RUN adduser -h /vlc -g "VLC User" -s /sbin/nologin -D vlc vlc

WORKDIR /vlc

COPY --chown=vlc:vlc ./start.sh ./

USER vlc

ENTRYPOINT ./start.sh
