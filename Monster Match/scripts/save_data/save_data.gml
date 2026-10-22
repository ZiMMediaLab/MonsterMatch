// Settings and best times, saved with ini files (browser builds keep them in local storage)

/// @function settings_load()
/// @description Loads the player's settings into globals. Called once at game start.
function settings_load()
{
    ini_open(SETTINGS_FILE);
    global.music_on   = ini_read_real("audio", "music", 1);
    global.sound_on   = ini_read_real("audio", "sound", 1);
    global.fullscreen = ini_read_real("display", "fullscreen", 0);
    global.difficulty = ini_read_real("game", "difficulty", Difficulty.EASY);
    ini_close();

    global.difficulty = clamp(global.difficulty, 0, Difficulty.COUNT - 1);

    if (os_browser == browser_not_a_browser)
    {
        window_set_fullscreen(global.fullscreen);
    }
}

/// @function settings_save()
/// @description Writes the current settings to disk.
function settings_save()
{
    ini_open(SETTINGS_FILE);
    ini_write_real("audio", "music", global.music_on);
    ini_write_real("audio", "sound", global.sound_on);
    ini_write_real("display", "fullscreen", global.fullscreen);
    ini_write_real("game", "difficulty", global.difficulty);
    ini_close();
}

/// @function best_time_get(_difficulty)
/// @description Most time left on a win for this difficulty, or -1 if never won.
/// @param {Real} _difficulty  A Difficulty value.
/// @returns {Real}
function best_time_get(_difficulty)
{
    ini_open(SCORES_FILE);
    var _best = ini_read_real("best", difficulty_settings(_difficulty).name, -1);
    ini_close();

    return _best;
}

/// @function best_time_submit(_difficulty, _time_left)
/// @description Saves the time if it beats the current best.
/// @param {Real} _difficulty  A Difficulty value.
/// @param {Real} _time_left   Seconds left on the clock when the round was won.
/// @returns {Bool} True if it's a new best.
function best_time_submit(_difficulty, _time_left)
{
    if (_time_left <= best_time_get(_difficulty))
    {
        return false;
    }

    ini_open(SCORES_FILE);
    ini_write_real("best", difficulty_settings(_difficulty).name, _time_left);
    ini_close();

    return true;
}

/// @function best_times_clear()
/// @description Deletes every saved best time.
function best_times_clear()
{
    ini_open(SCORES_FILE);
    ini_section_delete("best");
    ini_close();
}

/// @function play_sfx(_sound, [_pitch])
/// @description Plays a sound effect unless sounds are turned off in Options.
/// @param {Asset.GMSound} _sound    Sound to play.
/// @param {Real}          [_pitch]  1 is normal; higher sounds brighter.
function play_sfx(_sound, _pitch = 1)
{
    if (global.sound_on)
    {
        audio_play_sound(_sound, 0, false, 1, 0, _pitch);
    }
}
