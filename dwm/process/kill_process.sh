#!/bin/sh

# Running ps to get running processes and display in dmenu.
selected="$(ps --user "$(id -u)" -F | \
	dmenu -i -l 20 -p "Search for process to kill:" | \
	awk '{print $2" "$11}')";

# Nested 'if' statements.  The outer 'if' statement is what to do
# when we select one of the 'selected' options listed in dmenu.
if [ -n "$selected" ]; then
	answer="$(echo -e "No\nYes" | dmenu -i -p "Kill $selected?")"

	if [ "$answer" = "Yes" ]; then
		selpid="$(awk '{print $1}' <<< "$selected")";
		kill -9 "$selpid"
		echo "Process $selected has been killed." && exit 0
	fi

	if [ "$answer" == "No" ]; then
		echo "Program terminated." && exit 0
	fi
fi

exit 0
