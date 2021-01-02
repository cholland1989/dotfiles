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
