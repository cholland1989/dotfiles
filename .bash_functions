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
        PROBE=$(ffprobe -i "${1}" 2>&1 >/dev/null)
        H264=$(echo "${PROBE}" | grep "Video: h264" | wc --lines)
        FLAC=$(echo "${PROBE}" | grep "Audio: flac" | wc --lines)
        ENG0=$(echo "${PROBE}" | grep "0(eng): Audio" | wc --lines)
        ENG1=$(echo "${PROBE}" | grep "1(eng): Audio" | wc --lines)
        ENG2=$(echo "${PROBE}" | grep "2(eng): Audio" | wc --lines)
        SUBS=$(echo "${PROBE}" | grep "(eng): Audio" | wc --lines)
        ARGS="-map_metadata -1 -map_chapters -1"
        [[ "${H264}" -eq "1" ]] && ARGS="${ARGS} -c:v copy"
        [[ "${H264}" -ne "1" ]] && ARGS="${ARGS} -c:v h264 -preset slower -crf 15 -pix_fmt yuv420p"
        [[ "${FLAC}" -eq "0" ]] && ARGS="${ARGS} -c:a copy"
        [[ "${FLAC}" -ne "0" ]] && ARGS="${ARGS} -c:a ac3"
        [[ "${ENG0}" -eq "0" && "${ENG1}" -eq "0" && "${ENG2}" -ne "0" ]] && ARGS="${ARGS} -map 0:a:1"
        [[ "${SUBS}" -eq "0" ]] && ARGS="${ARGS} -c:s mov_text -metadata:s:s:0 language=eng"
        [[ "${SUBS}" -ne "0" ]] && ARGS="${ARGS} -metadata:s:a:0 language=eng"
        ffmpeg -i "${1}" ${ARGS} "${1%.*}.mp4"
        rename --expr 's/.*[sS](\d\d)[eE](\d\d).*/S$1E$2.mp4/' "${1%.*}.mp4"
    fi
}
