/// @description Text button defaults (set label and on_click after creating it)
label    = "";
on_click = undefined;   // function to run when clicked or tapped

pressed_here = false;   // the click started on this button

// True when the mouse (or a finger) is over the button.
is_hovered = function()
{
    draw_set_font(fnt_start);
    var _half_width  = string_width(label) / 2 + 12;
    var _half_height = string_height(label) / 2 + 4;

    return point_in_rectangle(mouse_x, mouse_y, x - _half_width, y - _half_height, x + _half_width, y + _half_height);
}
