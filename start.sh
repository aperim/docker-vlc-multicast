#!/usr/bin/env sh

if [ -z "${VLC_SOURCE_URL}" ]; then
    echo "Source URL not defined (VLC_SOURCE_URL)"
    exit 1
fi

if [ -z "${VLC_MULTICAST_IP}" ]; then
    VLC_MULTICAST_IP=234.0.0.0
fi

if [ -z "${VLC_MULTICAST_PORT}" ]; then
    VLC_MULTICAST_PORT=1234
fi

if [ -z "${VLC_BITRATE}" ]; then
    VLC_BITRATE=1000
fi

if [ -z "${VLC_CACHE}" ]; then
    VLC_CACHE=1000
fi

if [ -z "${VLC_THREADS}" ]; then
    VLC_THREADS=4
fi

if [ -z "${VLC_SAP_GROUP}" ]; then
    VLC_SAP_GROUP=Streams
fi

if [ -z "${VLC_SAP_NAME}" ]; then
    VLC_SAP_NAME=Video
fi

if [ -z "${VLC_ADAPTIVE_WIDTH}" ]; then
    VLC_ADAPTIVE_WIDTH=1280
fi

if [ -z "${VLC_ADAPTIVE_HEIGHT}" ]; then
    VLC_ADAPTIVE_HEIGHT=720
fi

if [ -z "${VLC_ADAPTIVE_BITRATE}" ]; then
    VLC_ADAPTIVE_BITRATE=2048
fi

if [ -z "${VLC_ADAPTIVE_LOGIC}" ]; then
    VLC_ADAPTIVE_LOGIC=highest
fi

if [ -z "${PORT}" ]; then
    PORT=4212
fi

if [ -z "${PASSWORD}" ]; then
    PASSWORD=vlcmulticast
fi

SOUT="#transcode{venc=x264{preset=ultrafast},vcodec=h264,threads=${VLC_THREADS},vb=${VLC_BITRATE}}:duplicate{dst='rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group=\"${VLC_SAP_GROUP}\",name=\"${VLC_SAP_NAME}\"}'}"

cat << EOF
Streaming: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Multicast: ${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Source: ${VLC_SOURCE_URL}
EOF

/usr/bin/vlc -I telnet --no-repeat --no-loop -vv ${VLC_SOURCE_URL} --network-caching=${VLC_CACHE} --telnet-password=${PASSWORD} --telnet-port=${PORT} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic=${VLC_ADAPTIVE_LOGIC} --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} --sout="${SOUT}" vlc://quit

cat << EOF
Stream Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Source of completed stream: ${VLC_SOURCE_URL}
EOF
