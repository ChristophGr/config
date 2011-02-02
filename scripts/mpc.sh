#!/bin/sh

if [ -z "$1" ]; then
  exit 0
fi

case "$1" in
load)
  exit 0
  ;;
stop)
  exit 0
  ;;
random)
  exit 0
  ;;
add)
  exit 0
  ;;
play)
  exit 0
  ;;
clear)
  exit 0
  ;;
*)
  mpc $@
  ;;
esac