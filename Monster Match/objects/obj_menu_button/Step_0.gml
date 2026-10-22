/// @description Click when the press and release both happen on this button
// Checking the press stops a click from the previous room landing on a button here
if (mouse_check_button_pressed(mb_left))
{
    pressed_here = is_hovered();
}

if (mouse_check_button_released(mb_left))
{
    if (pressed_here && is_hovered() && on_click != undefined)
    {
        play_sfx(snd_card_flip);
        on_click();
    }

    pressed_here = false;
}
