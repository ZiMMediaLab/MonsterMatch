/// @description Music, sounds, fullscreen (desktop only) and resetting best times
var _centre_x = room_width / 2;
var _y        = OPTIONS_FIRST_Y;

reset_armed = false;   // Reset needs two clicks

music_button = create_menu_button(_centre_x, _y, "", function()
{
    global.music_on = !global.music_on;
    settings_save();
    update_labels();
});
_y += OPTIONS_SPACING;

sound_button = create_menu_button(_centre_x, _y, "", function()
{
    global.sound_on = !global.sound_on;
    settings_save();
    update_labels();
});
_y += OPTIONS_SPACING;

// Browsers handle fullscreen themselves
fullscreen_button = noone;
if (os_browser == browser_not_a_browser)
{
    fullscreen_button = create_menu_button(_centre_x, _y, "", function()
    {
        global.fullscreen = !global.fullscreen;
        window_set_fullscreen(global.fullscreen);
        settings_save();
        update_labels();
    });
    _y += OPTIONS_SPACING;
}

reset_button = create_menu_button(_centre_x, _y, "", function()
{
    if (reset_armed)
    {
        best_times_clear();
        reset_armed = false;
        reset_button.label = "BEST TIMES CLEARED";
        return;
    }

    reset_armed = true;
    reset_button.label = "SURE? CLICK AGAIN";
});

create_menu_button(MENU_BACK_X, MENU_BACK_Y, "BACK", function()
{
    room_goto(rm_start_menu);
});


update_labels = function()
{
    music_button.label = "MUSIC " + (global.music_on ? "ON" : "OFF");
    sound_button.label = "SOUNDS " + (global.sound_on ? "ON" : "OFF");

    if (fullscreen_button != noone)
    {
        fullscreen_button.label = "FULLSCREEN " + (global.fullscreen ? "ON" : "OFF");
    }

    if (!reset_armed)
    {
        reset_button.label = "RESET BEST TIMES";
    }
}

update_labels();
