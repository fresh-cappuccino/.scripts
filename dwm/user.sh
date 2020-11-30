#!/bin/sh

user()
{
	user_=$(whoami)
	if [ "$user_" = "coffee" ] || [ "$user" = "cappuccino" ] ; then
		user_="☕$user_☕"
	fi
}
