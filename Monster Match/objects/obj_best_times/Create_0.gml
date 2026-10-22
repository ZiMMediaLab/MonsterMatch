/// @description "BEST TIMES" tab that drops down a list of best times
is_open      = false;
open_amount  = 0;         // 0 = rolled up, 1 = fully open (animates between)
close_timer  = 0;         // frames left before it rolls up on its own
pressed_here = false;

best_times = array_create(Difficulty.COUNT, -1);

// Reads the saved times so the list is current every time it opens.
refresh_times = function()
{
    for (var _i = 0; _i < Difficulty.COUNT; _i++)
    {
        best_times[_i] = best_time_get(_i);
    }
}

panel_height = function()
{
    return BEST_TIMES_PADDING * 2 + Difficulty.COUNT * BEST_TIMES_ROW_HEIGHT;
}

// True when the mouse is over the tab, or over the panel while it's open.
is_hovered = function()
{
    var _bottom = BEST_TIMES_Y + BEST_TIMES_TAB_HEIGHT + (panel_height() * open_amount);
    return point_in_rectangle(mouse_x, mouse_y, BEST_TIMES_RIGHT - BEST_TIMES_WIDTH, BEST_TIMES_Y, BEST_TIMES_RIGHT, _bottom);
}

toggle = function()
{
    is_open = !is_open;

    if (is_open)
    {
        refresh_times();
        close_timer = BEST_TIMES_AUTO_CLOSE * game_get_speed(gamespeed_fps);
    }
}
