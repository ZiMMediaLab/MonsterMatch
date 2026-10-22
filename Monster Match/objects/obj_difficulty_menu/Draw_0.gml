/// @description Show the rules for whichever difficulty is under the mouse
for (var _i = 0; _i < Difficulty.COUNT; _i++)
{
    if (difficulty_buttons[_i].is_hovered())
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_shadowed(room_width / 2, DIFFICULTY_HINT_Y, difficulty_summary(_i), fnt_timer, c_ltgray);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_colour(c_white);
        break;
    }
}
