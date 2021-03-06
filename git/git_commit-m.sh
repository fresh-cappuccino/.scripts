#!/bin/sh

[ X"" = X"$@" ] && echo "You need to type a message for the commit" && notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "You need to type a message for the commit" && exit

args=$@

git commit -m "$args"
[ $? -eq 0 ] && notify-send -i $HOME/.scripts/git/icons/git-logo.png "Git" "Files successfully committed to history" || (notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "An error occurred while trying to commit the files in history" && exit 1)
