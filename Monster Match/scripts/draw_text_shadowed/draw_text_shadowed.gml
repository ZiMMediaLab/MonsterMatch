/// @function draw_text_shadowed(_x, _y, _text, _font, _colour)
/// @description Draws text with a black drop shadow behind it.
///              Uses whatever alignment is currently set with draw_set_halign/valign.
/// @param {Real}            _x       X position.
/// @param {Real}            _y       Y position.
/// @param {String}          _text    Text to draw.
/// @param {Asset.GMFont}    _font    Font to use.
/// @param {Constant.Colour} _colour  Colour of the main text.
function draw_text_shadowed(_x, _y, _text, _font, _colour)
{
    draw_set_font(_font);

    draw_set_colour(c_black);
    draw_text(_x + TEXT_SHADOW_OFFSET, _y + TEXT_SHADOW_OFFSET, _text);

    draw_set_colour(_colour);
    draw_text(_x, _y, _text);
}
