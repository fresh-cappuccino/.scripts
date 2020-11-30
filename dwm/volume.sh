#!/bin/sh

volume()
{
	muted_=$(pamixer --get-mute)
	if [[ "$muted_" = "true" ]] ; then
		volume_="🎵 [-][-----------][🔇]"
	else
		num_vol=$(pamixer --get-volume)
		volume_="🎵 [$num_vol][${vol_bar:0:$(expr $num_vol / 10)}>${vol_space:0:$(expr 10 - $num_vol / 10)}][奄]"
	fi
}
