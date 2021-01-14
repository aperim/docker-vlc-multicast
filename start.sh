#!/usr/bin/env sh

if [ -z "${VLC_SOURCE_URL}" ]; then
    echo "RTSP URL not defined (VLC_SOURCE_URL)"
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

if [ -z "${VLC_SAP_GROUP}" ]; then
    VLC_SERVICE_GROUP=Streams
fi

if [ -z "${VLC_SAP_NAME}" ]; then
    VLC_SERVICE_GROUP=Video
fi

if [ -z "${VLC_ADAPTIVE_WIDTH}" ]; then
    VLC_ADAPTIVE_WIDTH=1280
fi

if [ -z "${VLC_ADAPTIVE_HEIGHT}" ]; then
    VLC_ADAPTIVE_HEIGHT=720
fi

if [ -z "${VLC_ADAPTIVE_BITRATE}" ]; then
    VLC_ADAPTIVE_BITRATE=100000
fi

if [ -z "${VLC_ADAPTIVE_LOGIC}" ]; then
    VLC_ADAPTIVE_LOGIC=highest
fi

cat << EOF > /vlc/stream.vlm
del all

new stream broadcast enabled
setup stream option network-caching=4000
setup stream input ${VLC_SOURCE_URL} loop
setup stream output #transcode{venc=x264{preset=ultrafast},vcodec=h264,threads=${VLC_BITRATE},vb=1000}:duplicate{dst='rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group="${VLC_SAP_GROUP}",name="${VLC_SAP_NAME}"}'}

control stream play
EOF

cat << EOF
Streaming: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Multicast: ${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Source: ${VLC_SOURCE_URL}
EOF

/usr/bin/vlc -I dummy --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic=${VLC_ADAPTIVE_LOGIC} --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} --vlm-conf=/vlc/stream.vlm

cat << EOF
Stream Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Source of completed stream: ${VLC_SOURCE_URL}
EOF
