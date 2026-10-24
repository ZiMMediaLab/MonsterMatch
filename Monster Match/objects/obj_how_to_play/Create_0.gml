/// @description Three pages of rules: the basics, the difficulties and the bonus items
page = 0;

// Leaving counts as having read the rules, so it won't open by itself again
leave = function()
{
    global.rules_seen = true;
    settings_save();
    room_goto(rm_start_menu);
}

turn_page = function(_step)
{
    var _next = clamp(page + _step, 0, HELP_PAGE_COUNT - 1);
    if (_next == page)
    {
        return;
    }

    page = _next;
    update_buttons();
}

update_buttons = function()
{
    prev_button.visible = (page > 0);
    next_button.label   = (page == HELP_PAGE_COUNT - 1) ? "DONE" : "NEXT";
}

create_menu_button(MENU_BACK_X, MENU_BACK_Y, "BACK", function()
{
    leave();
});

prev_button = create_menu_button(250, HELP_NAV_Y, "PREV", function()
{
    turn_page(-1);
});

next_button = create_menu_button(550, HELP_NAV_Y, "NEXT", function()
{
    if (page == HELP_PAGE_COUNT - 1)
    {
        leave();
        return;
    }

    turn_page(1);
});

update_buttons();


// Draws wrapped paragraphs from _y down and returns where the next line can start.
draw_paragraphs = function(_lines, _y)
{
    for (var _i = 0; _i < array_length(_lines); _i++)
    {
        _y += draw_text_ext_shadowed(HELP_LEFT, _y, _lines[_i], fnt_timer, c_ltgray, HELP_WIDTH) + HELP_LINE_GAP;
    }

    return _y;
}

// Item sprites animate at 4 frames a second, the same as in a round
item_frame = function(_sprite)
{
    return (current_time div 250) mod sprite_get_number(_sprite);
}

page_basics = function()
{
    draw_paragraphs(
    [
        "Click a card to turn it over, then click a second card.",
        "Same monster? The pair leaves the table. No match? Both flip back, so remember where they were!",
        "Find every pair before the timer at the top runs out. In the last " + string(HURRY_SECONDS) + " seconds the timer turns red and the music speeds up.",
        "ENTER deals a new round at any time. ESC goes back to the menu."
    ], HELP_BODY_Y);

    // A face-down card and a pair
    draw_sprite_ext(spr_cardback,    0, 290, 625, 0.7, 0.7, 0, c_white, 1);
    draw_sprite_ext(spr_draculacard, 0, 400, 625, 0.7, 0.7, 0, c_white, 1);
    draw_sprite_ext(spr_draculacard, 0, 510, 625, 0.7, 0.7, 0, c_white, 1);
}

page_difficulties = function()
{
    static _item_names = ["Potion", "Brain", "Scarab", "Ankh", "Basket"];
    var _y = HELP_BODY_Y;

    for (var _i = 0; _i < Difficulty.COUNT; _i++)
    {
        var _rules = difficulty_settings(_i);
        var _items = "";

        for (var _j = 0; _j < array_length(_rules.items); _j++)
        {
            _items += (_j > 0 ? ", " : "") + _item_names[_rules.items[_j]];
        }

        draw_text_shadowed(HELP_LEFT, _y, _rules.name, fnt_start, (_i == Difficulty.NIGHTMARE) ? c_red : c_orange);
        draw_text_shadowed(HELP_LEFT, _y + 32, difficulty_summary(_i), fnt_timer, c_ltgray);
        draw_text_shadowed(HELP_LEFT, _y + 60, "Items: " + _items, fnt_timer, c_gray);
        _y += 108;
    }

    draw_paragraphs(["Peek: every card shows for a moment before the round starts."], _y);
}

page_items = function()
{
    var _rows =
    [
        [Item.POTION, "POTION", "+" + string(POTION_SECONDS) + " seconds on the clock.", c_lime],
        [Item.BRAIN,  "BRAIN",  "Shows every card for a moment.", c_fuchsia],
        [Item.SCARAB, "SCARAB", "Makes one hidden pair glow.", c_aqua],
        [Item.ANKH,   "ANKH",   "+" + string(ANKH_SECONDS) + " seconds once, when time runs out.", c_yellow],
        [Item.BASKET, "BASKET", "Nightmare only: a treat... or a trick!", c_red]
    ];

    var _y = draw_paragraphs(["A match can drop an item where the pair was. Click it before it fades!"], HELP_BODY_Y) + 12;

    for (var _i = 0; _i < array_length(_rows); _i++)
    {
        var _row    = _rows[_i];
        var _sprite = item_sprite(_row[0]);

        draw_sprite_ext(_sprite, item_frame(_sprite), HELP_LEFT + 30, _y + 34, 0.75, 0.75, 0, c_white, 1);
        draw_text_shadowed(HELP_LEFT + 80, _y, _row[1], fnt_start, _row[3]);
        draw_text_shadowed(HELP_LEFT + 80, _y + 30, _row[2], fnt_timer, c_ltgray);
        _y += 82;
    }
}
