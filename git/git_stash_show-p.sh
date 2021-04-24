#!/bin/sh

[ X"" != X"$1" ] && stash="stash@{$1}"

git stash show -p $stash
