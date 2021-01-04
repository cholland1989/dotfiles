#!/usr/bin/env bash

# Remove all Docker containers and images.
function docker-clean() {
    if [ $(docker ps --all --quiet | wc --lines) -gt 0 ]; then
        docker stop $(docker ps --all --quiet)
        docker rm $(docker ps --all --quiet)
    fi
    if [ $(docker images --quiet | wc --lines) -gt 0 ]; then
        docker rmi $(docker images --quiet)
    fi
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
        for FILE in "${1}"/**/*.{m4v,mkv,avi}; do ffremux "${FILE}"; done
    elif [ -f "${1}" ]; then
        INDEX='BEGIN { FS = ":" } { print $1 }'
        PROBE=$(ffprobe -i "${1}" 2>&1 >/dev/null)
        VIDEO=$(echo "${PROBE}" | grep "Video:" | grep "Stream #")
        AUDIO=$(echo "${PROBE}" | grep "Audio:" | grep "Stream #")
        H264=$(echo "${VIDEO}" | grep -n "h264" | head -n 1 | awk "${INDEX}")
        FLAC==$(echo "${AUDIO}" | head -n 1 | grep "flac")
        ENGS=$(echo "${AUDIO}" | grep -n -E "(eng)|(und)|[^)]: Audio" | head -n 1)
        [ -n "${ENGS}" ] && FLAC=$(echo "${ENGS}" | grep "flac")
        ENGS=$(echo "${ENGS}" | awk "${INDEX}")
        ARGS="-map_metadata -1 -map_chapters -1"
        [ -n "${H264}" ] && ARGS="${ARGS} -c:v copy -map 0:v:$(expr ${H264} - 1)"
        [ -z "${H264}" ] && ARGS="${ARGS} -c:v h264 -preset slower -crf 15 -pix_fmt yuv420p -map 0:v:0"
        [ -n "${FLAC}" ] && ARGS="${ARGS} -c:a ac3"
        [ -z "${FLAC}" ] && ARGS="${ARGS} -c:a copy"
        [ -n "${ENGS}" ] && ARGS="${ARGS} -map 0:a:$(expr ${ENGS} - 1) -metadata:s:a:0 language=eng"
        [ -z "${ENGS}" ] && ARGS="${ARGS} -map 0:a:0 -c:s mov_text -metadata:s:s:0 language=eng"
        ffmpeg -i "${1}" ${ARGS} "${1%.*}.mp4"
        rename --expr 's/.*[sS](\d\d)[eE](\d\d).*/S$1E$2.mp4/' "${1%.*}.mp4"
    fi
}
