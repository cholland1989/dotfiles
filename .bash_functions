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
