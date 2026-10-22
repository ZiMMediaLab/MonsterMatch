/// @description Keep the timer in sync and start the music once it has loaded
if (alarm[ALARM_ROUND_TIMER] > 0)
{
    time_left = ceil(alarm[ALARM_ROUND_TIMER] / game_get_speed(gamespeed_fps));
}

// HTML5: start the music once it has loaded
if (music_waiting)
{
    start_music();
}
