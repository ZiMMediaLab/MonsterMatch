/// @description Open/close on click, roll up after a few seconds untouched, animate
if (mouse_check_button_pressed(mb_left))
{
    pressed_here = is_hovered();
}

if (mouse_check_button_released(mb_left))
{
    if (pressed_here && is_hovered())
    {
        play_sfx(snd_card_flip);
        toggle();
    }

    pressed_here = false;
}

if (is_open)
{
    if (is_hovered())
    {
        close_timer = BEST_TIMES_AUTO_CLOSE * game_get_speed(gamespeed_fps);
    }
    else if (--close_timer <= 0)
    {
        is_open = false;
    }
}

// Slide toward open or closed
open_amount = lerp(open_amount, is_open ? 1 : 0, BEST_TIMES_SLIDE_SPEED);
if (abs(open_amount - (is_open ? 1 : 0)) < 0.01)
{
    open_amount = is_open ? 1 : 0;
}
