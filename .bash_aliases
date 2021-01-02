#!/usr/bin/env bash

# Preserve environment for sudo commands.
alias sudo="sudo -E "

# Terminate process unconditionally.
alias kill="kill -SIGKILL"

# Report disk usage in human readable format.
alias df="df --human-readable"

# List files and directories in human readable format.
alias ls="ls -l --literal --classify --human-readable --color"

# Create parent directories as needed.
alias mkdir="mkdir --parents"

# Change file mode recursively.
alias chmod="chmod --recursive"

# Change file owner recursively.
alias chown="chown --recursive"

# Display new output to file.
alias tail="tail --follow --lines 128"

# Replace diff with colordiff.
alias diff="colordiff"

# Replace Vi with Vim.
alias vi="vim"

# Retain TextMate shortcut for Sublime Text.
alias mate="subl"

# Prefer symbolic links.
alias ln="ln --symbolic"

# Copy files and directories recursively.
alias cp="cp --recursive"

# Copy files and directories recursively.
alias scp="scp -r -p"

# Sync files and directories recursively.
alias rsync="rsync --archive --delete --compress --info=progress2"

# Archive recursively and include symbolic links.
alias zip="zip --recurse-paths --symlinks --quiet"

# Delete files and directories recursively.
alias rm="rm --recursive --force"

# Download best available video and audio from YouTube.
alias yt="youtube-dl --output '%(title)s.%(ext)s' --format bestvideo[ext=mp4]+bestaudio[ext=m4a] --merge-output-format mp4 --ignore-errors"

# Hide files and directories.
[ "${TERM_PROGRAM}" == "iTerm.app" ] && alias hide="chflags hidden"

# Show files and directories.
[ "${TERM_PROGRAM}" == "iTerm.app" ] && alias show="chflags nohidden"

# Open a new Cygwin terminal.
[ "${TERM_PROGRAM}" == "mintty" ] && alias cygwin="mintty -d - &"

# Open files and directories with default handler.
[ "${TERM_PROGRAM}" == "mintty" ] && alias open="cygstart"
