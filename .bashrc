#!/usr/bin/env bash

# Load options.
[ -f "${HOME}/.bash_options" ] && source "${HOME}/.bash_options"

# Load exports.
[ -f "${HOME}/.bash_exports" ] && source "${HOME}/.bash_exports"

# Load aliases.
[ -f "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"

# Load functions.
[ -f "${HOME}/.bash_functions" ] && source "${HOME}/.bash_functions"

# Load completions.
[ -f "/usr/local/etc/bash_completion" ] && source "/usr/local/etc/bash_completion"
