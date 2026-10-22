/// @description Draw the timer and the end-of-round banner (GUI layer, always above the cards)
var _centre_x = room_width / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_shadowed(_centre_x, TIMER_Y, "Time Left: " + string(time_left), fnt_timer, c_white);

if (global.game_state == GameState.WON || global.game_state == GameState.LOST)
{
    var _message = (global.game_state == GameState.WON) ? "YOU WON!" : "YOU LOST!";

    // Dark band so the message stays readable over the cards
    draw_set_alpha(0.65);
    draw_set_colour(c_black);
    draw_rectangle(0, BANNER_TOP, room_width, BANNER_BOTTOM, false);
    draw_set_alpha(1);

    draw_set_valign(fa_middle);
    draw_text_shadowed(_centre_x, BANNER_TITLE_Y, _message, fnt_state, c_red);

    if (can_restart())
    {
        draw_text_shadowed(_centre_x, BANNER_PROMPT_Y, "Click to play again", fnt_timer, c_white);
    }
}

// Reset draw settings so nothing else inherits them
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
