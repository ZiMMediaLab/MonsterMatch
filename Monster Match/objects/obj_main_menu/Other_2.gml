/// @description Game Start - load saved settings once, and show How to Play to new players
settings_load();

if (!global.rules_seen)
{
    room_goto(rm_how_to_play);
}
