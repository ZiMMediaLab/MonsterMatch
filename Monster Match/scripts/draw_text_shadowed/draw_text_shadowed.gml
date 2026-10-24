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

/// @function draw_text_ext_shadowed(_x, _y, _text, _font, _colour, _width)
/// @description Like draw_text_shadowed, but wraps the text at _width.
/// @param {Real}            _x       X position.
/// @param {Real}            _y       Y position.
/// @param {String}          _text    Text to draw.
/// @param {Asset.GMFont}    _font    Font to use.
/// @param {Constant.Colour} _colour  Colour of the main text.
/// @param {Real}            _width   Maximum line width in pixels.
/// @returns {Real} Height of the drawn text, so the next paragraph can go underneath.
function draw_text_ext_shadowed(_x, _y, _text, _font, _colour, _width)
{
    draw_set_font(_font);

    draw_set_colour(c_black);
    draw_text_ext(_x + TEXT_SHADOW_OFFSET, _y + TEXT_SHADOW_OFFSET, _text, -1, _width);

    draw_set_colour(_colour);
    draw_text_ext(_x, _y, _text, -1, _width);

    return string_height_ext(_text, -1, _width);
}
