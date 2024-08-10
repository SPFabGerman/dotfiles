#!/usr/bin/env zsh

# Supported commands
grc_cmds=(
    curl
    du
    id
    ip
    iptables
    lsblk
    lsmod
    lsof
    lspci
    ping
    ps
    sysctl
    traceroute
    uptime
)

# Set alias for available commands.
for cmd in $grc_cmds ; do
  if (( $+commands[$cmd] )) ; then
    $cmd() {
      grc --colour=auto ${commands[$0]} "$@"
    }
  fi
done

# Clean up variables
unset cmds cmd
