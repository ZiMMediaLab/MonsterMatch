/// @description Tab, then the panel as far as it has slid open
var _right  = BEST_TIMES_RIGHT;
var _left   = BEST_TIMES_RIGHT - BEST_TIMES_WIDTH;
var _tab_y  = BEST_TIMES_Y + BEST_TIMES_TAB_HEIGHT / 2;
var _top    = BEST_TIMES_Y + BEST_TIMES_TAB_HEIGHT;
var _bottom = _top + panel_height() * open_amount;

// Tab, lined up with the panel's right edge
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
var _arrow = is_open ? " -" : " +";
draw_text_shadowed(_right - 8, _tab_y, "BEST TIMES" + _arrow, fnt_start, (is_hovered() || is_open) ? c_orange : c_white);

if (open_amount > 0)
{
    // Panel background
    draw_set_alpha(0.85);
    draw_set_colour(c_black);
    draw_rectangle(_left, _top, _right, _bottom, false);
    draw_set_alpha(1);
    draw_set_colour(c_orange);
    draw_rectangle(_left, _top, _right, _bottom, true);

    // Rows appear as the panel reaches them
    for (var _i = 0; _i < Difficulty.COUNT; _i++)
    {
        var _row_y = _top + BEST_TIMES_PADDING + (_i + 0.5) * BEST_TIMES_ROW_HEIGHT;
        if (_row_y + BEST_TIMES_ROW_HEIGHT / 2 > _bottom)
        {
            break;
        }

        var _time = (best_times[_i] >= 0) ? string_format(best_times[_i], 1, 1) + "s" : "--";

        draw_set_halign(fa_left);
        draw_text_shadowed(_left + 12, _row_y, difficulty_settings(_i).name, fnt_timer, c_white);
        draw_set_halign(fa_right);
        draw_text_shadowed(_right - 12, _row_y, _time, fnt_timer, (best_times[_i] >= 0) ? c_orange : c_gray);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
