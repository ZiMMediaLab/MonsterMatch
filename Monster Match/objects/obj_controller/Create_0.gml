/// @description Build the deck for the chosen difficulty and start the first round

randomize();

// Draw the HUD in room coordinates on every platform (desktop window or scaled browser canvas)
display_set_gui_size(room_width, room_height);

global.game_state = GameState.PAUSED;

rules = difficulty_settings(global.difficulty);

time_left       = rules.seconds;
round_over_time = 0;        // current_time (ms) when the last round ended
penalty_time    = -1;       // current_time (ms) of the last Nightmare penalty, for the "-2"

pairs_found  = 0;
misses       = 0;
win_time     = 0;           // exact seconds left when the round was won
is_new_best  = false;

music          = -1;        // sound instance of the playing music
music_waiting  = false;     // music still loading (HTML5)
is_hurrying    = false;     // last few seconds: music sped up

first_pick  = noone;        // first card turned over this turn
second_pick = noone;        // second card turned over this turn

// The deck is built once; every round reshuffles the same card instances
deck = ds_list_create();
create_deck(deck, rules.pairs);

// Back to the difficulty menu (top-left, works with mouse or touch)
back_button = create_menu_button(HUD_SIDE_MARGIN + 45, TIMER_Y + 14, "BACK", function()
{
    room_goto(rm_difficulty);
});


// Turns every card face down and forgets the current picks.
clear_picks = function()
{
    cover_all_cards(deck);
    first_pick  = noone;
    second_pick = noone;
}

// Seconds left on the round timer, with fractions.
seconds_left = function()
{
    return max(alarm[ALARM_ROUND_TIMER], 0) / game_get_speed(gamespeed_fps);
}

// Starts this difficulty's music loop, or retries from Step until it has loaded (HTML5).
start_music = function()
{
    if (!global.music_on || (music != -1 && audio_is_playing(music)))
    {
        music_waiting = false;
        return;
    }

    if (!audio_sound_is_playable(rules.music))
    {
        music_waiting = true;
        return;
    }

    music = audio_play_sound(rules.music, 0, true);
    music_waiting = false;

    if (is_hurrying)
    {
        audio_sound_pitch(music, HURRY_PITCH);
    }
}

stop_music = function()
{
    audio_stop_sound(rules.music);
    music = -1;
    music_waiting = false;
    is_hurrying   = false;
}

// Last few seconds: speed the music up a little.
start_hurry = function()
{
    is_hurrying = true;

    if (music != -1)
    {
        audio_sound_pitch(music, HURRY_PITCH);
    }
}

// Starts (or restarts) a round: reshuffle, show the cards if this difficulty peeks, then play.
start_round = function()
{
    alarm[ALARM_PAIR_CHECK]  = -1;   // cancel any pair that was mid-check
    alarm[ALARM_ROUND_TIMER] = -1;
    alarm[ALARM_PEEK]        = -1;

    clear_picks();
    shuffle_cards(deck, rules.columns);

    time_left    = rules.seconds;
    pairs_found  = 0;
    misses       = 0;
    is_new_best  = false;
    penalty_time = -1;

    audio_stop_sound(snd_evil_laugh);
    stop_music();

    if (rules.peek > 0)
    {
        reveal_all_cards(deck);
        global.game_state = GameState.PAUSED;
        alarm[ALARM_PEEK] = rules.peek * game_get_speed(gamespeed_fps);
    }
    else
    {
        begin_play();
    }
}

// Turns the cards over and starts the clock.
begin_play = function()
{
    cover_all_cards(deck);

    alarm[ALARM_ROUND_TIMER] = rules.seconds * game_get_speed(gamespeed_fps);
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
    stop_music();

    if (_won)
    {
        global.game_state = GameState.WON;
        is_new_best = best_time_submit(global.difficulty, win_time);
    }
    else
    {
        global.game_state = GameState.LOST;
        time_left = 0;
        play_sfx(snd_evil_laugh);
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
        play_sfx(snd_card_flipback);
        clear_picks();
        return;
    }

    play_sfx(snd_card_flip);
    _card.is_face_up = true;

    if (first_pick == noone)
    {
        first_pick = _card;
        return;
    }

    // Second card: lock input briefly so the player can see both faces
    second_pick = _card;
    global.game_state = GameState.PAUSED;
    alarm[ALARM_PAIR_CHECK] = rules.reveal * game_get_speed(gamespeed_fps);
}

// Compares the two picked cards once the reveal delay is over.
resolve_picks = function()
{
    // The round may have ended (or restarted) while the pair was showing
    if (global.game_state != GameState.PAUSED || first_pick == noone || second_pick == noone)
    {
        return;
    }

    var _is_match = (first_pick.pair_id == second_pick.pair_id);

    if (_is_match)
    {
        first_pick.is_matched  = true;
        first_pick.visible     = false;
        second_pick.is_matched = true;
        second_pick.visible    = false;
        pairs_found++;
    }
    else
    {
        play_sfx(snd_card_flipback);
        misses++;
    }

    clear_picks();

    if (!_is_match && rules.penalty > 0)
    {
        apply_penalty();

        if (global.game_state == GameState.LOST)
        {
            return;   // the penalty ran the clock out
        }
    }

    if (check_victory(deck))
    {
        win_time = seconds_left();
        end_round(true);
    }
    else
    {
        global.game_state = GameState.PLAYING;
    }
}

// Nightmare: a wrong pair takes time off the clock.
apply_penalty = function()
{
    var _frames = rules.penalty * game_get_speed(gamespeed_fps);
    penalty_time = current_time;

    if (alarm[ALARM_ROUND_TIMER] <= _frames)
    {
        end_round(false);
        return;
    }

    alarm[ALARM_ROUND_TIMER] -= _frames;
}

// True once a round has ended and the short restart delay has passed.
can_restart = function()
{
    var _round_over = (global.game_state == GameState.WON || global.game_state == GameState.LOST);
    return _round_over && (current_time - round_over_time >= RESTART_DELAY_MS);
}


start_round();
