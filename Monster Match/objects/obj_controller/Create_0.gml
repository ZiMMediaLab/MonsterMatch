/// @description Build the deck and start the first round

randomize();

// Draw the HUD in room coordinates on every platform (desktop window or scaled browser canvas)
display_set_gui_size(room_width, room_height);

global.game_state = GameState.PAUSED;

time_left       = PLAY_TIME_SECONDS;
round_over_time = 0;        // current_time (ms) when the last round ended

music_waiting   = false;    // music still loading (HTML5)

first_pick  = noone;        // first card turned over this turn
second_pick = noone;        // second card turned over this turn

// The deck is built once; every round reshuffles the same 24 card instances
deck = ds_list_create();
create_deck(deck, PAIR_COUNT);


// Turns every card face down and forgets the current picks.
clear_picks = function()
{
    cover_all_cards(deck);
    first_pick  = noone;
    second_pick = noone;
}

// Starts the music, or retries from Step until it has loaded (HTML5).
start_music = function()
{
    if (audio_is_playing(snd_game_music))
    {
        music_waiting = false;
        return;
    }

    if (!audio_sound_is_playable(snd_game_music))
    {
        music_waiting = true;
        return;
    }

    var _music = audio_play_sound(snd_game_music, 0, false);
    music_waiting = false;

    // Skip ahead if loading took a moment, so the song still ends with the timer
    var _seconds_elapsed = PLAY_TIME_SECONDS - (alarm[ALARM_ROUND_TIMER] / game_get_speed(gamespeed_fps));
    if (_seconds_elapsed > 0.1)
    {
        audio_sound_set_track_position(_music, _seconds_elapsed);
    }
}

// Starts (or restarts) a round: reshuffle, reset the timer, restart the music.
start_round = function()
{
    alarm[ALARM_PAIR_CHECK] = -1;   // cancel any pair that was mid-check
    clear_picks();
    shuffle_cards(deck);

    time_left = PLAY_TIME_SECONDS;
    alarm[ALARM_ROUND_TIMER] = PLAY_TIME_SECONDS * game_get_speed(gamespeed_fps);

    audio_stop_sound(snd_evil_laugh);
    audio_stop_sound(snd_game_music);
    start_music();

    global.game_state = GameState.PLAYING;
}

// Ends the round as a win or a loss.
end_round = function(_won)
{
    alarm[ALARM_ROUND_TIMER] = -1;
    alarm[ALARM_PAIR_CHECK]  = -1;
    first_pick  = noone;
    second_pick = noone;
    round_over_time = current_time;
    music_waiting   = false;

    if (_won)
    {
        global.game_state = GameState.WON;
    }
    else
    {
        global.game_state = GameState.LOST;
        time_left = 0;
        audio_stop_sound(snd_game_music);
        audio_play_sound(snd_evil_laugh, 0, false);
        reveal_all_cards(deck);   // show the player what they missed
    }
}

// Called by obj_card when the player clicks or taps it.
pick_card = function(_card)
{
    if (global.game_state != GameState.PLAYING || _card.is_matched)
    {
        return;
    }

    // Picking the first card again turns it back over
    if (_card == first_pick)
    {
        audio_play_sound(snd_card_flipback, 0, false);
        clear_picks();
        return;
    }

    audio_play_sound(snd_card_flip, 0, false);
    _card.is_face_up = true;

    if (first_pick == noone)
    {
        first_pick = _card;
        return;
    }

    // Second card: lock input briefly so the player can see both faces
    second_pick = _card;
    global.game_state = GameState.PAUSED;
    alarm[ALARM_PAIR_CHECK] = PAIR_REVEAL_SECONDS * game_get_speed(gamespeed_fps);
}

// Compares the two picked cards once the reveal delay is over.
resolve_picks = function()
{
    // The round may have ended (or restarted) while the pair was showing
    if (global.game_state != GameState.PAUSED || first_pick == noone || second_pick == noone)
    {
        return;
    }

    if (first_pick.pair_id == second_pick.pair_id)
    {
        first_pick.is_matched  = true;
        first_pick.visible     = false;
        second_pick.is_matched = true;
        second_pick.visible    = false;
    }
    else
    {
        audio_play_sound(snd_card_flipback, 0, false);
    }

    clear_picks();

    if (check_victory(deck))
    {
        end_round(true);
    }
    else
    {
        global.game_state = GameState.PLAYING;
    }
}

// True once a round has ended and the short restart delay has passed.
can_restart = function()
{
    var _round_over = (global.game_state == GameState.WON || global.game_state == GameState.LOST);
    return _round_over && (current_time - round_over_time >= RESTART_DELAY_MS);
}


start_round();
