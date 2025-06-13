#!/usr/bin/env bash

# Preserve environment for sudo commands.
alias sudo="sudo -E "

# Terminate process unconditionally.
alias kill="kill -SIGKILL"

# Report disk usage in human readable format.
alias df="df -h"

# List files and directories in human readable format.
[ "${TERM_PROGRAM}" == "ghostty" ] && alias ls="ls -lhF" || alias ls="ls -lhF --color"

# Create parent directories as needed.
alias mkdir="mkdir -p"

# Change file mode recursively.
alias chmod="chmod -R"

# Change file owner recursively.
alias chown="chown -R"

# Display new output to file.
alias tail="tail -128f"

# Replace diff with colordiff.
alias diff="colordiff"

# Replace Vi with Vim.
alias vi="vim"

# Retain TextMate shortcut for Sublime Text.
alias mate="subl"

# Prefer symbolic links.
alias ln="ln -s"

# Copy files and directories recursively.
alias cp="cp -R"

# Copy files and directories recursively.
alias scp="scp -rp"

# Sync files and directories recursively.
alias rsync="rsync --archive --delete --compress --info=progress2"

# Archive recursively and include symbolic links.
alias zip="zip -qry"

# Delete files and directories recursively.
alias rm="rm -rf"

# Capture network traffic.
alias pcap="sudo tcpdump -w $(date +%s).pcap"

# Replace Docker with Podman.
alias docker="podman"

# Download best available video and audio from YouTube.
alias yt="yt-dlp --output '%(title)s.%(ext)s' --format bestvideo[ext=mp4]+bestaudio[ext=m4a] --merge-output-format mp4 --ignore-errors"

# Extract Zstandard archives.
alias unzstd="tar --use-compress-program=zstd -xvf"

# Print stack trace to console.
alias stack="curl -s http://127.0.0.1:6060/debug/pprof/goroutine?debug=1 > stack.out && cat stack.out | less; rm stack.out"

# Print heap dump to console.
alias heap="curl -s http://127.0.0.1:6060/debug/pprof/heap > heap.out && go tool pprof -text heap.out | less; rm heap.out"

# Print mutex contention to console.
alias mutex="curl -s http://127.0.0.1:6060/debug/pprof/mutex > mutex.out && go tool pprof -text mutex.out | less; rm mutex.out"

# Hide files and directories.
[ "${TERM_PROGRAM}" == "ghostty" ] && alias hide="chflags hidden"

# Show files and directories.
[ "${TERM_PROGRAM}" == "ghostty" ] && alias show="chflags nohidden"

# Open a new Cygwin terminal.
[ "${TERM_PROGRAM}" == "mintty" ] && alias cygwin="mintty -d - &"

# Open files and directories with default handler.
[ "${TERM_PROGRAM}" == "mintty" ] && alias open="cygstart"
