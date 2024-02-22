#!/usr/bin/env bash

# Load configuration for interactive shells.
[[ "$-" == *i* ]] && [ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"; cd "${BASH_HOME:-${HOME}}"
