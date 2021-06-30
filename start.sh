#!/usr/bin/env sh

# VLC=/Applications/VLC.app/Contents/MacOS/VLC
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

if [ -z "${VLC_VERBOSE}" ]; then
    VLC_VERBOSE=0
fi

if [ -z "${PORT}" ]; then
    PORT=4212
fi

if [ -z "${PASSWORD}" ]; then
    PASSWORD=vlcmulticast
fi

VLC_VENC="x264"
VLC_AENC="ffmpeg"

# VLC_SFILTER="audiobargraph_v{barWidth=20,position=1,alarm=1}"
# VLC_AFILTER="audiobargraph_a{bargraph=1,address=127.0.0.1,port=${VLC_RC_PORT},connection_reset=1,bargraph_repetition=22,silence=1,repetition_time=1000,time_window=10000,alarm_threshold=0.01}"
# VLC_AFILTER="{audiobargraph_a}"
VLC_VFILTER="canvas{width=${VLC_ADAPTIVE_WIDTH},height=${VLC_ADAPTIVE_HEIGHT},aspect=${VLC_ASPECT_RATIO}}"
VLC_VIDEO_CODEC="h264"
VLC_AUDIO_CODEC="mp4a"
VLC_DESTINATION="'rtp{access=udp,mux=ts,ttl=15,dst=${VLC_MULTICAST_IP},port=${VLC_MULTICAST_PORT},sdp=sap://,group=\"${VLC_SAP_GROUP}\",name=\"${VLC_SAP_NAME}\"}'"
VLC_SCALE="1"

VLC_EXTRA_OPTIONS_AUDIO_FILTER="--audiobargraph_a-bargraph 1 --audiobargraph_a-address 127.0.0.1 --audiobargraph_a-port ${VLC_RC_PORT} --audiobargraph_a-connection_reset 1 --audiobargraph_a-bargraph_repetition 4 --audiobargraph_a-silence 1 --audiobargraph_a-repetition_time 1000 --audiobargraph_a-time_window=10000 --audiobargraph_a-alarm_threshold 0.01"
VLC_AVCODEC_OPTIONS="--avcodec-dr 0 --avcodec-hurry-up 1 --avcodec-skip-frame 1 --avcodec-skip-idct 1 --sout-avcodec-strict -2"

if [ ! -z "$VLC_SFILTER" ]; then
    VLC_SFILTER=",sfilter=${VLC_SFILTER}"
else
    VLC_SFILTER=""
fi

if [ ! -z "$VLC_AFILTER" ]; then
    VLC_AFILTER=",afilter=${VLC_AFILTER}"
else
    VLC_AFILTER=""
fi

if [ ! -z "$VLC_VFILTER" ]; then
    VLC_VFILTER=",vfilter=${VLC_VFILTER}"
else
    VLC_VFILTER=""
fi

if [ ! -z "$VLC_VIDEO_CODEC" ]; then
    VLC_VIDEO_CODEC=",vcodec=${VLC_VIDEO_CODEC}"
else
    VLC_VIDEO_CODEC=""
fi

if [ ! -z "$VLC_AUDIO_CODEC" ]; then
    VLC_AUDIO_CODEC=",acodec=${VLC_AUDIO_CODEC}"
else
    VLC_AUDIO_CODEC=""
fi

if [ ! -z "$VLC_DESTINATION" ]; then
    VLC_DESTINATION=",dst=${VLC_DESTINATION}"
else
    VLC_DESTINATION=""
fi

if [ ! -z "$VLC_X264" ]; then
    VLC_X264="${VLC_VENC}{${VLC_X264}}"
else
    VLC_X264=""
fi

if [ ! -z "$VLC_VENC" ]; then
    VLC_VENC=",venc=${VLC_X264}"
else
    VLC_VENC=""
fi

if [ ! -z "$VLC_AENC" ]; then
    VLC_AENC=",aenc=${VLC_AENC}"
else
    VLC_AENC=""
fi

if [ ! -z "$VLC_SCALE" ]; then
    VLC_SCALE=",scale=${VLC_SCALE}"
else
    VLC_SCALE=""
fi

if [ ! -z "$VLC_THREADS" ]; then
    VLC_THREADS=",threads=${VLC_THREADS}"
else
    VLC_THREADS=""
fi

if [ ! -z "$VLC_AUDIO_BITRATE" ]; then
    VLC_AUDIO_BITRATE=",ab=${VLC_AUDIO_BITRATE}"
else
    VLC_AUDIO_BITRATE=""
fi

if [ ! -z "$VLC_AUDIO_CHANNELS" ]; then
    VLC_AUDIO_CHANNELS=",channels=${VLC_AUDIO_CHANNELS}"
else
    VLC_AUDIO_CHANNELS=""
fi

if [ ! -z "$VLC_FPS" ]; then
    VLC_FPS=",fps=${VLC_FPS}"
else
    VLC_FPS=""
fi

if [ ! -z "$VLC_BITRATE" ]; then
    VLC_BITRATE=",vb=${VLC_BITRATE}"
else
    VLC_BITRATE=""
fi

if [ ! -z "$VLC_ADAPTIVE_WIDTH" ]; then
    VLC_WIDTH=",width=${VLC_ADAPTIVE_WIDTH}"
else
    VLC_WIDTH=""
fi

if [ ! -z "$VLC_ADAPTIVE_HEIGHT" ]; then
    VLC_HEIGHT=",height=${VLC_ADAPTIVE_HEIGHT}"
else
    VLC_HEIGHT=""
fi


SOUT="#transcode{${VLC_THREADS}${VLC_VENC}${VLC_AENC}${VLC_SCALE}${VLC_VIDEO_CODEC}${VLC_AUDIO_CODEC}${VLC_AUDIO_BITRATE}${VLC_AUDIO_CHANNELS}${VLC_FPS}${VLC_BITRATE}${VLC_AFILTER}${VLC_SFILTER}${VLC_VFILTER}${VLC_WIDTH}${VLC_HEIGHT}}:duplicate{${VLC_DESTINATION}}"

cat << EOF
Streaming: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Multicast: rtp://@${VLC_MULTICAST_IP}:${VLC_MULTICAST_PORT}
Source: ${VLC_SOURCE_URL}
SOUT: ${SOUT}
EOF

${VLC} -I telnet --verbose ${VLC_VERBOSE} --no-disable-screensaver --extraintf="rc" --rc-host="0.0.0.0:${VLC_RC_PORT}" ${VLC_AVCODEC_OPTIONS} --no-repeat --no-loop "${VLC_SOURCE_URL}" --network-caching=${VLC_CACHE} --telnet-password="${PASSWORD}" --telnet-port=${PORT} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} ${VLC_EXTRA_OPTIONS_AUDIO_FILTER} --sout="${SOUT}" vlc://quit

cat << EOF
Stream Finished: ${VLC_SAP_GROUP}/${VLC_SAP_NAME}
Source of completed stream: ${VLC_SOURCE_URL}
EOF