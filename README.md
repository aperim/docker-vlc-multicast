# VLC to Multicast
--

## What does it do?
Reflects a stream to multicast.

## Who is it for?
You, I guess?!

## How do I do?
```bash
docker run -it --rm --network host -e VLC_SOURCE_URL="http://example.com/stream/exciting_video" docker pull ghcr.io/aperim/vlc-multicast:latest
```

## That's it?
Yes.

## Important
This is multicast - make sure you set `network` to `host`.