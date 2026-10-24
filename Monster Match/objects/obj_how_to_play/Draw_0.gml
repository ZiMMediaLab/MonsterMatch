/// @description Darken the title art and draw the current page
var _headings = ["THE BASICS", "DIFFICULTIES", "BONUS ITEMS"];

draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(45, 35, room_width - 45, room_height - 35, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_shadowed(room_width / 2, HELP_TITLE_Y, "HOW TO PLAY", fnt_state, c_orange);
draw_text_shadowed(room_width / 2, HELP_HEADING_Y, _headings[page], fnt_start, c_white);
draw_text_shadowed(room_width / 2, HELP_NAV_Y, string(page + 1) + " OF " + string(HELP_PAGE_COUNT), fnt_start, c_gray);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

switch (page)
{
    case 0: page_basics();       break;
    case 1: page_difficulties(); break;
    case 2: page_items();        break;
}

draw_set_colour(c_white);
