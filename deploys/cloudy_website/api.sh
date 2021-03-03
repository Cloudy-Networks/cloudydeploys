#!/usr/bin/bash

case "$1" in
  stop)
    rm /usr/share/caddy/api/instance-action 2>/dev/null
    cp /usr/share/caddy/api/stop /usr/share/caddy/api/instance-action
    ;;
  terminate)
    rm /usr/share/caddy/api/instance-action 2>/dev/null
    cp /usr/share/caddy/api/terminate /usr/share/caddy/api/instance-action
    ;;
  *)
    rm /usr/share/caddy/api/instance-action 2>/dev/null
    ;;
  esac
