#!/usr/bin/env bash

current_java_version=`archlinux-java get|tail -n1`
java_lines=`archlinux-java status|wc -l`

# Running ps to get running processes and display in dmenu.
selected="$(archlinux-java status|tail -n$((java_lines - 1))|\
	dmenu -i -l 21 -p "Select java version to be applied [current: $current_java_version]"|\
	awk '{print $1}')";

# Nested 'if' statements.  The outer 'if' statement is what to do
# when we select one of the 'selected' options listed in dmenu.
if [ -n "$selected" ]; then
	answer="$(echo -e "No\nYes" | dmenu -i -p "Apply $selected?")"

	if [ "$answer" = "Yes" ]; then
		[[ "$current_java_version" = *"$selected"* ]] && echo "$selected is already the current java version" && notify-send "Java" "$selected is already the current java version" && exit 0
		st sudo archlinux-java set "$selected"
		[ $? -eq 0 ] && notify-send "Java" "Java version successfully changed to $selected" || notify-send "Error" "An error occurred while trying to change java to version $selected"
		echo "Java version $selected has been set" && exit 0
	fi

	if [ "$answer" == "No" ]; then
		echo "Program terminated." && exit 0
	fi
fi

exit 0
