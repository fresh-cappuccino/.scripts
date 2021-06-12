#!/bin/sh

args=$@

[ X"" = X"$args" ] && echo "You need to type a message for the commit" && notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "You need to type a message for the commit" && exit

git add .
[ $? -eq 0 ] && notify-send -i $HOME/.scripts/git/icons/git-logo.png "Git" "Files successfully added to stash" || (notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "An error occurred while trying to add the files in git" && exit 1)

git commit -m "$args"
[ $? -eq 0 ] && notify-send -i $HOME/.scripts/git/icons/git-logo.png "Git" "Files successfully committed to history" || (notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "An error occurred while trying to commit the files in history" && exit 1)

git push
[ $? -eq 0 ] && notify-send -i $HOME/.scripts/git/icons/git-logo.png "Git" "Files successfully pushed to remote repository" || (notify-send -i $HOME/.scripts/git/icons/git-error.png "Error" "An error occurred while trying to push the files to the remote repository" && exit 1)
