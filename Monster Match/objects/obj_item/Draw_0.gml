/// @description Pop in, then flicker during the last second
var _age   = current_time - spawn_time;
var _scale = min(1, _age / 150);
var _alpha = 1;

if (_age > ITEM_LIFETIME_MS - ITEM_FADE_MS)
{
    _alpha = ((_age div 100) mod 2 == 0) ? 1 : 0.3;
}

draw_sprite_ext(sprite_index, image_index, x, y, _scale, _scale, 0, c_white, _alpha);
