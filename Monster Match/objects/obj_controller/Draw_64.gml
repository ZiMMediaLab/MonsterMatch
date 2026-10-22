/// @description Draw the HUD and the end-of-round banner (GUI layer, always above the cards)
var _centre_x = room_width / 2;

// Timer (centre) and pairs found (right)
draw_set_valign(fa_top);
draw_set_halign(fa_center);
var _timer_colour = (time_left <= HURRY_SECONDS && global.game_state != GameState.WON) ? c_red : c_white;
draw_text_shadowed(_centre_x, TIMER_Y, "Time Left: " + string(time_left), fnt_timer, _timer_colour);

draw_set_halign(fa_right);
draw_text_shadowed(room_width - HUD_SIDE_MARGIN, TIMER_Y, "Pairs " + string(pairs_found) + "/" + string(rules.pairs), fnt_timer, c_white);

draw_set_halign(fa_center);

// Nightmare penalty flash
if (penalty_time >= 0 && current_time - penalty_time < PENALTY_SHOW_MS)
{
    draw_text_shadowed(_centre_x, TIMER_Y + 32, "-" + string(rules.penalty), fnt_timer, c_red);
}

// Item pop-up ("+5 SEC", "TRICK!")
if (message_time >= 0 && current_time - message_time < MESSAGE_SHOW_MS)
{
    draw_text_shadowed(_centre_x, ITEM_MESSAGE_Y, message, fnt_timer, message_colour);
}

// Ankh held: small icon left of the pairs counter
if (has_second_life)
{
    draw_sprite_ext(spr_item_ankh, current_time div 300, room_width - 190, TIMER_Y + 14, 0.45, 0.45, 0, c_white, 1);
}

// Cards showing before the clock starts
if (alarm[ALARM_PEEK] > 0)
{
    draw_text_shadowed(_centre_x, TIMER_Y + 32, "Memorize!", fnt_timer, c_orange);
}

if (global.game_state == GameState.WON || global.game_state == GameState.LOST)
{
    var _won     = (global.game_state == GameState.WON);
    var _message = _won ? "YOU WON!" : "YOU LOST!";

    // Dark band so the message stays readable over the cards
    draw_set_alpha(0.65);
    draw_set_colour(c_black);
    draw_rectangle(0, BANNER_TOP, room_width, BANNER_BOTTOM, false);
    draw_set_alpha(1);

    draw_set_valign(fa_middle);
    draw_text_shadowed(_centre_x, BANNER_TITLE_Y, _message, fnt_state, c_red);

    var _stats;
    if (_won)
    {
        _stats = string_format(win_time, 1, 1) + "s left - " + string(misses) + " misses";
        if (is_new_best)
        {
            _stats += " - NEW BEST!";
        }
    }
    else
    {
        _stats = string(pairs_found) + " of " + string(rules.pairs) + " pairs found";
    }
    draw_text_shadowed(_centre_x, BANNER_STATS_Y, _stats, fnt_timer, _won && is_new_best ? c_orange : c_white);

    if (can_restart())
    {
        draw_text_shadowed(_centre_x, BANNER_PROMPT_Y, "Click to play again", fnt_timer, c_white);
    }
}

// Reset draw settings so nothing else inherits them
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
