#!/usr/bin/env bash

yes_no() {
	[ -z $answer ] && read -p "GhostScript? [y/N] " answer

	if [[ $answer = "y"* ]] || [[ $answer = "Y"* ]] ; then
		answer=yes
	elif [[ -z $answer ]] || [[ $answer = "n"* ]] || [[ $answer = "N"* ]] ; then
		answer=no
	fi
}

yes_no

[[ $answer = "yes" ]] && gs || git status
