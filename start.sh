#!/usr/bin/env sh

VLC=/usr/bin/vlc

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

if [ -z "${VLC_AUDIO_BITRATE}" ]; then
    VLC_AUDIO_BITRATE=192
fi

if [ -z "${VLC_AUDIO_CHANNELS}" ]; then
    VLC_AUDIO_CHANNELS=2
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

VLC_SFILTER="audiobargraph_v{barWidth=20,position=1,alarm=1}"
# VLC_AFILTER="audiobargraph_a{bargraph=1,address=127.0.0.1,port=${VLC_RC_PORT},connection_reset=1,bargraph_repetition=22,silence=1,repetition_time=1000,time_window=10000,alarm_threshold=0.01}"
VLC_AFILTER="{audiobargraph_a}"
VLC_VFILTER="canvas{width=${VLC_ADAPTIVE_WIDTH},height=${VLC_ADAPTIVE_HEIGHT},aspect=${VLC_ASPECT_RATIO}}"
VLC_VIDEO_CODEC="h264"
VLC_AUDIO_CODEC="mp4a"
VLC_DESTINATION="'rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group=\"${VLC_SAP_GROUP}\",name=\"${VLC_SAP_NAME}\"}'"
VLC_EXTRA_OPTIONS_AUDIO_FILTER="--audiobargraph_a-bargraph 1 --audiobargraph_a-address 127.0.0.1 --audiobargraph_a-port ${VLC_RC_PORT} --audiobargraph_a-connection_reset 1 --audiobargraph_a-bargraph_repetition 1 --audiobargraph_a-silence 1 --audiobargraph_a-repetition_time 1000 --audiobargraph_a-time_window=10000 --audiobargraph_a-alarm_threshold 0.01"

#acodec=${VLC_AUDIO_CODEC},ab=${VLC_AUDIO_BITRATE},channels=${VLC_AUDIO_CHANNELS},deinterlace

SOUT="#transcode{venc=x264{${VLC_X264}},scale=1,threads=${VLC_THREADS},sfilter=${VLC_SFILTER},width=${VLC_ADAPTIVE_WIDTH},height=${VLC_ADAPTIVE_HEIGHT},vfilter=${VLC_VFILTER},vcodec=${VLC_VIDEO_CODEC},fps=${VLC_FPS},vb=${VLC_BITRATE},afilter=${VLC_AFILTER}}:duplicate{dst=${VLC_DESTINATION}}"

cat << EOF
Streaming: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Multicast: rtp://@${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Source: ${VLC_SOURCE_URL}
SOUT: ${SOUT}
EOF

${VLC} -I telnet --verbose 3 --no-disable-screensaver --extraintf="rc" --rc-host="127.0.0.1:${VLC_RC_PORT}" --no-repeat --no-loop "${VLC_SOURCE_URL}" --network-caching=${VLC_CACHE} --telnet-password="${PASSWORD}" --telnet-port=${PORT} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} ${VLC_EXTRA_OPTIONS_AUDIO_FILTER} --sout="${SOUT}" vlc://quit

cat << EOF
Stream Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Source of completed stream: ${VLC_SOURCE_URL}
EOF