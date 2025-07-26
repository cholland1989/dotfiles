#!/usr/bin/env bash

# Remove all Docker containers and images.
function docker-clean() {
    if [ $(docker ps -aq | wc -l) -gt 0 ]; then
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
    fi
    if [ $(docker images -q | wc -l) -gt 0 ]; then
        docker rmi -f $(docker images -q)
    fi
}

# Generate password based on pattern.
function pwgen() {
    PASSWORD=""
    UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    LOWER="abcdefghijklmnopqrstuvwxyz"
    DIGIT="1234567890"
    SYMBOL="!@#$%^&*()"
    ASCII="${UPPER}${LOWER}${DIGIT}${SYMBOL}"
    for (( INDEX = 0; INDEX < ${#1}; INDEX++ )); do
        CHAR="${1:${INDEX}:1}"
        if [[ "${CHAR}" == "A" ]]; then
            PASSWORD="${PASSWORD}${UPPER:$((RANDOM % ${#UPPER})):1}"
        elif [[ "${CHAR}" == "a" ]]; then
            PASSWORD="${PASSWORD}${LOWER:$((RANDOM % ${#LOWER})):1}"
        elif [[ "${CHAR}" == "#" ]]; then
            PASSWORD="${PASSWORD}${DIGIT:$((RANDOM % ${#DIGIT})):1}"
        elif [[ "${CHAR}" == "@" ]]; then
            PASSWORD="${PASSWORD}${SYMBOL:$((RANDOM % ${#SYMBOL})):1}"
        else
            PASSWORD="${PASSWORD}${ASCII:$((RANDOM % ${#ASCII})):1}"
        fi
    done
    echo "${PASSWORD}"
}

# Split a video at the specified timestamp.
function ffsplit() {
    ffmpeg -i "${2}" -t ${1} -c copy "${2%.*}_1.${2##*.}" -ss ${1} -c copy "${2%.*}_2.${2##*.}"
}

# Convert and rename one or more videos.
function ffremux() {
    if [ -z "${1}" ]; then
        ffremux "."
    elif [ -d "${1}" ]; then
        for FILE in "${1}"/**/*.{m4v,mkv,avi,ts}; do ffremux "${FILE}"; done
    elif [ -f "${1}" ]; then
        INDEX='BEGIN { FS = ":" } { print $1 }'
        PROBE=$(ffprobe -i "${1}" 2>&1 >/dev/null)
        VIDEO=$(echo "${PROBE}" | grep "Video:" | grep "Stream #")
        AUDIO=$(echo "${PROBE}" | grep "Audio:" | grep "Stream #")
        H264=$(echo "${VIDEO}" | grep -n -E "(h264)|(hevc)" | grep -v "High 10" | head -n 1 | awk "${INDEX}")
        FLAC=$(echo "${AUDIO}" | head -n 1 | grep "flac")
        ENGS=$(echo "${AUDIO}" | grep -n -E "(eng)|(und)|[^)]: Audio" | grep -v "truehd" | head -n 1)
        [ -n "${ENGS}" ] && FLAC=$(echo "${ENGS}" | grep "flac")
        ENGS=$(echo "${ENGS}" | awk "${INDEX}")
        ARGS="-map_metadata -1 -map_chapters -1"
        [ -n "${H264}" ] && ARGS="${ARGS} -c:v copy -map 0:v:$(expr ${H264} - 1)"
        [ -z "${H264}" ] && ARGS="${ARGS} -c:v h264 -preset slower -crf 15 -pix_fmt yuv420p -map 0:v:0"
        [ -n "${FLAC}" ] && ARGS="${ARGS} -c:a ac3"
        [ -z "${FLAC}" ] && ARGS="${ARGS} -c:a copy"
        [ -n "${ENGS}" ] && ARGS="${ARGS} -map 0:a:$(expr ${ENGS} - 1) -metadata:s:a:0 language=eng"
        [ -z "${ENGS}" ] && ARGS="${ARGS} -map 0:a:0 -c:s mov_text -metadata:s:s:0 language=eng -map 0:s:0"
        ffmpeg -i "${1}" ${ARGS} "${1%.*}.mp4"
        rename --expr 's/.*[sS](\d\d)[eE](\d\d).*/S$1E$2.mp4/' "${1%.*}.mp4"
    fi
}

# Convert FLAC/MP4 audio to LAME encoded MP3.
function ffaudio() {
    if [ -z "${1}" ]; then
        ffaudio "."
    elif [ -d "${1}" ]; then
        for FILE in "${1}"/**/*.{flac,m4a,mp4,mkv,wav}; do ffaudio "${FILE}"; done
    elif [ -f "${1}" ]; then
        ffmpeg -i "${1}" -c:v copy -c:a libmp3lame -q:a 0 "${1%.*}.mp3"
    fi
}

# Convert MP3 audio to AAC encoded MP4.
function ffvideo() {
    if [ -z "${1}" ]; then
        ffvideo "."
    elif [ -d "${1}" ]; then
        for FILE in "${1}"/**/*.mp3; do ffvideo "${FILE}"; done
    elif [ -f "${1}" ]; then
        ffmpeg -i "${1}" -c:a aac -b:a 192k "${1%.*}.m4a"
    fi
}

# Convert Unix timestamp to date.
function ts() {
    if [ "${TERM_PROGRAM}" == "iTerm.app" ]; then
        date -r "${1}" +'%Y-%m-%d %H:%M:%S'
    else
        date -d "@${1}" +'%Y-%m-%d %H:%M:%S'
    fi
}
