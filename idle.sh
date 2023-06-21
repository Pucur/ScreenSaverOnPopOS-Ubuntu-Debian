# check the correct display
export DISPLAY=:1.0
# enumerate all the attached screens
displays="1"
checkFullscreen()
{
    # loop through every display looking for a fullscreen window
    for display in $displays
    do
        #get id of active window and clean output
        activ_win_id=`DISPLAY=:${display} xprop -root _NET_ACTIVE_WINDOW`
        activ_win_id=${activ_win_id:40:9}
        
        # Check if Active Window (the foremost window) is in fullscreen state
        isActivWinFullscreen=`DISPLAY=:${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN`
        if [[ "$isActivWinFullscreen" != *NET_WM_STATE_FULLSCREEN* ]];then
                checkIdle
	    fi
    done
}


checkIdle()
{
# run on your user, not as root, if not working, use sudo -u $YOURUSERNAME
idle=$(xprintidle)
if [ $idle -gt "120000" -a $idle -lt "900000" ]
then
                xfce4-screensaver-command -d && xfce4-screensaver-command -a
	    fi

        if [[ $idle -gt "900000" ]]
then
   xdg-screensaver lock
   sleep 1
   xfce4-screensaver-command -d
   sleep 1
   gnome-screensaver-command -l
        fi
        
echo $idle
}
while sleep $((60)); do
echo $idle
    checkFullscreen
done
