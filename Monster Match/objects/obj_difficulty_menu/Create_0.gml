/// @description One button per difficulty, the best times drop-down, and a Back button
difficulty_buttons = array_create(Difficulty.COUNT, noone);

for (var _i = 0; _i < Difficulty.COUNT; _i++)
{
    // Methods don't capture local variables, so the difficulty is bound in a struct
    var _on_click = method({ difficulty: _i }, function()
    {
        global.difficulty = difficulty;
        settings_save();
        room_goto(rm_game);
    });

    difficulty_buttons[_i] = create_menu_button(room_width / 2, DIFFICULTY_FIRST_Y + (_i * DIFFICULTY_SPACING), difficulty_settings(_i).name, _on_click);
}

create_menu_button(MENU_BACK_X, MENU_BACK_Y, "BACK", function()
{
    room_goto(rm_start_menu);
});

instance_create_layer(0, 0, CARD_LAYER, obj_best_times);
