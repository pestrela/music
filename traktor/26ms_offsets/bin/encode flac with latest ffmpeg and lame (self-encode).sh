#!/usr/bin/env sh

# $ ffmpeg -v
# ffmpeg version 3.2.12-1~deb9u1 Copyright (c) 2000-2018 the FFmpeg developers
# built with gcc 6.3.0 (Debian 6.3.0-18+deb9u1) 20170516
# configuration: --prefix=/usr --extra-version='1~deb9u1' --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --enable-gpl --disable-stripping --enable-avresample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libebur128 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libmp3lame --enable-libopenjpeg --enable-libopenmpt --enable-libopus
# --enable-libpulse --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libopencv --enable-libx264 --enable-shared
# libavutil      55. 34.101 / 55. 34.101
# libavcodec     57. 64.101 / 57. 64.101
# libavformat    57. 56.101 / 57. 56.101
# libavdevice    57.  1.100 / 57.  1.100
# libavfilter     6. 65.100 /  6. 65.100
# libavresample   3.  1.  0 /  3.  1.  0
# libswscale      4.  2.100 /  4.  2.100
# libswresample   2.  3.100 /  2.  3.100
# libpostproc    54.  1.100 / 54.  1.100

# $ flac -v
# flac 1.3.2

# lame -v
# LAME 64bits version 3.99.5 (http://lame.sf.net)

a=Hot\ Stuff\ -\ Donna\ Summer.flac

# lavc cbr 320
# has_shift
ffmpeg -i "$a" -c:a libmp3lame -b:a 320k -c:v copy -id3v2_version 3 -write_id3v1 1 self-encode-lavc-cbr-320.mp3

# lavc vbr 0
# has_shift
ffmpeg -i "$a" -c:a libmp3lame -q:a 0 -c:v copy -id3v2_version 3 -write_id3v1 1 self-encode-lavc-vbr-0.mp3

# following code taken from https://wiki.archlinux.org/index.php/Convert_FLAC_to_MP3#Without_FFmpeg

ARTIST=$(metaflac "$a" --show-tag=ARTIST | sed s/.*=//g)
TITLE=$(metaflac "$a" --show-tag=TITLE | sed s/.*=//g)
ALBUM=$(metaflac "$a" --show-tag=ALBUM | sed s/.*=//g)
GENRE=$(metaflac "$a" --show-tag=GENRE | sed s/.*=//g)
TRACKNUMBER=$(metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g)
DATE=$(metaflac "$a" --show-tag=DATE | sed s/.*=//g)

# lame cbr 320
# no_shift
flac -c -d "$a" | lame -b 320 --add-id3v2 --pad-id3v2 --ignore-tag-errors \
    --ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM"  --tg "$GENRE" \
    --tn "$TRACKNUMBER" --ty "$DATE" - self-encode-lame-cbr-320.mp3

# lame vbr 0
# no_shift
flac -c -d "$a" | lame -V 0 --add-id3v2 --pad-id3v2 --ignore-tag-errors \
    --ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM"  --tg "$GENRE" \
    --tn "$TRACKNUMBER" --ty "$DATE" - self-encode-lame-vbr-0.mp3