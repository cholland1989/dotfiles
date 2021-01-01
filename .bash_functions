#!/usr/bin/env bash

# Remove all Docker containers and images.
function docker-clean() {
    # Check for Docker containers.
    if [ $(docker ps -aq | wc -l) -gt 0 ]; then
        # Stop all Docker containers.
        docker stop $(docker ps -aq)
        # Remove all Docker containers.
        docker rm $(docker ps -aq)
    fi
    # Check for Docker images.
    if [ $(docker images -q | wc -l) -gt 0 ]; then
        # Remove all Docker images.
        docker rmi $(docker images -q)
    fi
}
