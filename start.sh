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
    VLC_BITRATE=1024
fi

if [ -z "${VLC_CACHE}" ]; then
    VLC_CACHE=1024
fi

if [ -z "${VLC_THREADS}" ]; then
    VLC_THREADS=$(nproc --all)
fi

if [ -z "${VLC_SAP_GROUP}" ]; then
    VLC_SAP_GROUP=Streams
fi

if [ -z "${VLC_SAP_NAME}" ]; then
    VLC_SAP_NAME=Video
fi

if [ -z "${VLC_ASPECT_RATIO}" ]; then
    VLC_ASPECT_RATIO=16:9
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

if [ -z "${VLC_X264}" ]; then
    VLC_X264="preset=ultrafast,tune=zerolatency,keyint=30,bframes=0,ref=1,level=30,profile=baseline,hrd=cbr,crf=20,ratetol=1.0,vbv-maxrate=${VLC_BITRATE},vbv-bufsize=${VLC_BITRATE},lookahead=0"
fi

if [ -z "${VLC_FPS}" ]; then
    VLC_FPS=15
fi

if [ -z "${VLC_RC_PORT}" ]; then
    VLC_RC_PORT=10101
fi

if [ -z "${PORT}" ]; then
    PORT=4212
fi

if [ -z "${PASSWORD}" ]; then
    PASSWORD=vlcmulticast
fi

SOUT="#transcode{aspect-ratio=${VLC_ASPECT_RATIO},vfilter=canvas{width=${VLC_ADAPTIVE_WIDTH},height=${VLC_ADAPTIVE_HEIGHT}},venc=x264{${VLC_X264}},vcodec=h264,fps=${VLC_FPS},threads=${VLC_THREADS},vb=${VLC_BITRATE},scale=1,acodec=mp4a,ab=128,channels=2}:duplicate{dst='rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group=\"${VLC_SAP_GROUP}\",name=\"${VLC_SAP_NAME}\"}'}"

cat << EOF
Streaming: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Multicast: rtp://@${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Source: ${VLC_SOURCE_URL}
SOUT: ${SOUT}
EOF

/usr/bin/vlc --no-disable-screensaver -I telnet --rc-host 0.0.0.0:${VLC_RC_PORT} --no-repeat --no-loop "${VLC_SOURCE_URL}" --network-caching=${VLC_CACHE} --telnet-password="${PASSWORD}" --telnet-port=${PORT} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} --sout="${SOUT}" vlc://quit

cat << EOF
Stream Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Source of completed stream: ${VLC_SOURCE_URL}
EOF