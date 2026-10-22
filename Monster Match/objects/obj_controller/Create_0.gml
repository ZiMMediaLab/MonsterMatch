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

drops_this_round = 0;       // bonus items dropped so far
has_second_life  = false;   // picked up an ankh this round
message          = "";      // short pop-up under the timer ("+5 SEC", "TRICK!")
message_colour   = c_white;
message_time     = -1;      // current_time (ms) the message appeared

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

// A potion pushed the clock back above the hurry mark.
end_hurry = function()
{
    is_hurrying = false;

    if (music != -1)
    {
        audio_sound_pitch(music, 1);
    }
}

// Starts (or restarts) a round: reshuffle, show the cards if this difficulty peeks, then play.
start_round = function()
{
    alarm[ALARM_PAIR_CHECK]  = -1;   // cancel any pair that was mid-check
    alarm[ALARM_ROUND_TIMER] = -1;
    alarm[ALARM_PEEK]        = -1;
    alarm[ALARM_BRAIN]       = -1;

    clear_items();
    clear_picks();
    shuffle_cards(deck, rules.columns);

    time_left    = rules.seconds;
    pairs_found  = 0;
    misses       = 0;
    is_new_best  = false;
    penalty_time = -1;

    drops_this_round = 0;
    has_second_life  = false;
    message_time     = -1;

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
    alarm[ALARM_BRAIN]       = -1;
    first_pick  = noone;
    second_pick = noone;
    round_over_time = current_time;
    has_second_life = false;
    clear_items();
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
    var _slot_x   = first_pick.x;
    var _slot_y   = first_pick.y;

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

        if (_is_match)
        {
            try_drop_item(_slot_x, _slot_y);
        }
    }
}

// Nightmare: a wrong pair takes time off the clock.
apply_penalty = function()
{
    var _frames = rules.penalty * game_get_speed(gamespeed_fps);
    penalty_time = current_time;

    if (alarm[ALARM_ROUND_TIMER] <= _frames)
    {
        time_up();
        return;
    }

    alarm[ALARM_ROUND_TIMER] -= _frames;
}

// The clock hit zero: an ankh buys a few more seconds, otherwise the round is lost.
time_up = function()
{
    if (has_second_life)
    {
        has_second_life = false;
        alarm[ALARM_ROUND_TIMER] = ANKH_SECONDS * game_get_speed(gamespeed_fps);
        flash_message("SECOND LIFE!", c_yellow);
        play_sfx(snd_card_flip, 0.7);
        return;
    }

    end_round(false);
}

#region Bonus items

// Removes any item still waiting to be picked up.
clear_items = function()
{
    with (obj_item)
    {
        instance_destroy();
    }
}

// Shows a short pop-up under the timer.
flash_message = function(_text, _colour)
{
    message        = _text;
    message_colour = _colour;
    message_time   = current_time;
}

// After a match: maybe drop an item into the empty slot.
try_drop_item = function(_x, _y)
{
    if (drops_this_round >= rules.max_drops || random(1) >= rules.drop_chance)
    {
        return;
    }

    var _item = rules.items[irandom(array_length(rules.items) - 1)];
    var _drop = instance_create_layer(_x, _y, CARD_LAYER, obj_item);
    _drop.item         = _item;
    _drop.sprite_index = item_sprite(_item);

    drops_this_round++;
}

// Called by obj_item when the player clicks or taps it.
collect_item = function(_drop)
{
    if (global.game_state == GameState.WON || global.game_state == GameState.LOST)
    {
        return;
    }

    var _item = _drop.item;
    instance_destroy(_drop);

    play_sfx(snd_card_flip, 1.5);
    use_item(_item, "");
}

// Applies an item's effect. _prefix is added to the pop-up ("TREAT! ").
use_item = function(_item, _prefix)
{
    var _fps = game_get_speed(gamespeed_fps);

    switch (_item)
    {
        case Item.POTION:
            alarm[ALARM_ROUND_TIMER] += POTION_SECONDS * _fps;   // Step un-hurries the music if needed
            flash_message(_prefix + "+" + string(POTION_SECONDS) + " SEC", c_lime);
            break;

        case Item.BRAIN:
            // Cancel a pair that's mid-check, then show every card for a moment
            alarm[ALARM_PAIR_CHECK] = -1;
            clear_picks();
            reveal_all_cards(deck);
            global.game_state = GameState.PAUSED;
            alarm[ALARM_BRAIN] = BRAIN_SECONDS * _fps;
            flash_message(_prefix + "BIG BRAIN!", c_fuchsia);
            break;

        case Item.SCARAB:
            mark_random_pair();
            flash_message(_prefix + "SEEKER!", c_aqua);
            break;

        case Item.ANKH:
            has_second_life = true;
            flash_message(_prefix + "SECOND LIFE READY", c_yellow);
            break;

        case Item.BASKET:
            if (rules.tricks && random(1) < TRICK_CHANCE)
            {
                shuffle_unmatched();
                play_sfx(snd_card_flipback, 0.6);
                flash_message("TRICK! CARDS SHUFFLED", c_red);
            }
            else
            {
                var _treats = [Item.POTION, Item.BRAIN, Item.SCARAB];
                use_item(_treats[irandom(array_length(_treats) - 1)], "TREAT! ");
            }
            break;
    }
}

// Scarab: lands on a random unmatched card and makes it and its partner glow.
mark_random_pair = function()
{
    var _choices = [];
    var _count   = ds_list_size(deck);

    for (var _i = 0; _i < _count; _i++)
    {
        var _card = deck[| _i];
        if (!_card.is_matched && !_card.is_face_up)
        {
            array_push(_choices, _card);
        }
    }

    if (array_length(_choices) == 0)
    {
        return;
    }

    var _target  = _choices[irandom(array_length(_choices) - 1)];
    var _glow_to = current_time + SCARAB_GLOW_MS;

    for (var _j = 0; _j < _count; _j++)
    {
        var _other = deck[| _j];
        if (_other.pair_id == _target.pair_id)
        {
            _other.glow_until = _glow_to;
        }
    }

    _target.scarab_until = _glow_to;
}

// Basket trick: the cards still on the table swap places.
shuffle_unmatched = function()
{
    alarm[ALARM_PAIR_CHECK] = -1;
    clear_picks();

    var _cards     = [];
    var _positions = [];
    var _count     = ds_list_size(deck);

    for (var _i = 0; _i < _count; _i++)
    {
        var _card = deck[| _i];
        if (!_card.is_matched)
        {
            array_push(_cards, _card);
            array_push(_positions, [_card.x, _card.y]);
        }
    }

    array_shuffle_ext(_positions);

    for (var _j = 0; _j < array_length(_cards); _j++)
    {
        _cards[_j].x = _positions[_j][0];
        _cards[_j].y = _positions[_j][1];
    }

    if (global.game_state == GameState.PAUSED && alarm[ALARM_BRAIN] < 0)
    {
        global.game_state = GameState.PLAYING;
    }
}

#endregion

// True once a round has ended and the short restart delay has passed.
can_restart = function()
{
    var _round_over = (global.game_state == GameState.WON || global.game_state == GameState.LOST);
    return _round_over && (current_time - round_over_time >= RESTART_DELAY_MS);
}


start_round();
