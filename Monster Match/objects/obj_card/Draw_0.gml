/// @description Draw the card, plus the scarab's glow and the scarab itself
draw_self();

if (current_time < glow_until)
{
    var _pulse = 0.35 + 0.25 * sin(current_time / 90);

    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_aqua, _pulse);
    gpu_set_blendmode(bm_normal);

    draw_set_colour(c_aqua);
    draw_rectangle(bbox_left - 2, bbox_top - 2, bbox_right + 2, bbox_bottom + 2, true);
    draw_set_colour(c_white);
}

if (current_time < scarab_until)
{
    draw_sprite_ext(spr_item_scarab, current_time div 250, x, y - 40, 0.7, 0.7, 0, c_white, 1);
}
