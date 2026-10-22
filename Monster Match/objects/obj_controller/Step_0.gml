/// @description Keep the timer in sync and start the music once it has loaded
if (alarm[ALARM_ROUND_TIMER] > 0)
{
    time_left = ceil(seconds_left());

    if (!is_hurrying && time_left <= HURRY_SECONDS)
    {
        start_hurry();
    }
}

// HTML5: start the music once it has loaded
if (music_waiting)
{
    start_music();
}
