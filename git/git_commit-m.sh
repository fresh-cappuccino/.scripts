#!/bin/sh

[[ -z $@ ]] && echo "You need to type a message for the commit" && exit

args=$@

git commit -m "$args"
