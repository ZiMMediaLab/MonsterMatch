/// @description Label, orange on hover
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text_shadowed(x, y, label, fnt_start, is_hovered() ? c_orange : c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
