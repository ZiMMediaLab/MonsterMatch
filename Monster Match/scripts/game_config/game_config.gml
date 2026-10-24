// Game settings

enum GameState
{
    PAUSED,   // input locked (cards showing at the start, or a pair is being shown)
    PLAYING,  // player can turn cards over
    WON,      // every pair found before time ran out
    LOST      // time ran out
}

enum Difficulty
{
    EASY,
    MEDIUM,
    HARD,
    NIGHTMARE,
    COUNT
}

enum Item
{
    POTION,   // +5 seconds
    BRAIN,    // every card shows for a moment
    SCARAB,   // marks one unmatched pair
    ANKH,     // one extra life when time runs out
    BASKET    // random bonus, or a trick on Nightmare
}

#region Round rules
#macro RESTART_DELAY_MS     750    // stops a frantic last click from instantly restarting
#macro PENALTY_SHOW_MS      700    // how long the "-2" shows under the timer
#macro HURRY_SECONDS        10     // music speeds up and the timer turns red
#macro HURRY_PITCH          1.08
#endregion

#region obj_controller alarm slots
#macro ALARM_ROUND_TIMER   0
#macro ALARM_PAIR_CHECK    1
#macro ALARM_PEEK          2
#macro ALARM_BRAIN         3
#endregion

#region Bonus items
// Matching a pair can drop an item into the empty slot. Click it before it fades.
#macro ITEM_LIFETIME_MS    3000
#macro ITEM_FADE_MS        1000   // flickers during its last second
#macro POTION_SECONDS      5
#macro BRAIN_SECONDS       1
#macro SCARAB_GLOW_MS      1500
#macro ANKH_SECONDS        5
#macro TRICK_CHANCE        0.35   // Nightmare basket: chance it's a trick
#macro MESSAGE_SHOW_MS     1200
#macro ITEM_MESSAGE_Y      45     // under the timer, above the top row of cards
#endregion

#region Table layout
// Card sprites are 100x150 with a centred origin
#macro CARD_LAYER          "Instances"
#macro GRID_CENTRE_X       400
#macro GRID_CENTRE_Y       400
#macro CARD_SPACING_X      110
#macro CARD_SPACING_Y      160
#endregion

#region HUD layout
#macro TEXT_SHADOW_OFFSET  3
#macro TIMER_Y             13
#macro HUD_SIDE_MARGIN     20
#macro BANNER_TOP          310
#macro BANNER_BOTTOM       490
#macro BANNER_TITLE_Y      355
#macro BANNER_STATS_Y      410
#macro BANNER_PROMPT_Y     455
#endregion

#region Menu layout
// Buttons sit under the row of monsters on the title art
#macro DIFFICULTY_FIRST_Y  510
#macro DIFFICULTY_SPACING  50
#macro DIFFICULTY_HINT_Y   705    // rules for the difficulty under the mouse
#macro OPTIONS_FIRST_Y     520
#macro OPTIONS_SPACING     55

// Back button in the top-left corner, level with the BEST TIMES tab
#macro MENU_BACK_X         105
#macro MENU_BACK_Y         72
#macro HOW_TO_PLAY_X       165    // start menu: HOW TO PLAY sits in the same corner
#endregion

#region How to Play screen
#macro HELP_PAGE_COUNT     3
#macro HELP_LEFT           110
#macro HELP_WIDTH          580    // text wraps at this width
#macro HELP_TITLE_Y        95
#macro HELP_HEADING_Y      160
#macro HELP_BODY_Y         215
#macro HELP_LINE_GAP       14     // space between paragraphs
#macro HELP_NAV_Y          735
#endregion

#region Best times drop-down (top-right, clear of the title)
#macro BEST_TIMES_RIGHT        750    // right edge, just inside the frame
#macro BEST_TIMES_Y            55
#macro BEST_TIMES_WIDTH        250
#macro BEST_TIMES_TAB_HEIGHT   34
#macro BEST_TIMES_ROW_HEIGHT   28
#macro BEST_TIMES_PADDING      8
#macro BEST_TIMES_AUTO_CLOSE   5      // seconds untouched before it rolls up
#macro BEST_TIMES_SLIDE_SPEED  0.25
#endregion

#region Save files
#macro SETTINGS_FILE       "settings.ini"
#macro SCORES_FILE         "scores.ini"
#endregion

/// @function difficulty_settings(_difficulty)
/// @description Returns the rules for a difficulty.
///              pairs: matching pairs on the table, columns: cards per row,
///              seconds: round length, reveal: how long a picked pair stays up,
///              peek: seconds every card is shown before the round starts,
///              penalty: seconds lost for a wrong pair, music: the looping track,
///              drop_chance: chance a match drops an item, max_drops: items per round,
///              items: which items can drop, tricks: the basket can backfire.
/// @param {Real} _difficulty  A Difficulty value.
/// @returns {Struct}
function difficulty_settings(_difficulty)
{
    static _settings =
    [
        {
            name: "EASY", pairs: 6, columns: 4, seconds: 90, reveal: 0.8, peek: 3, penalty: 0, music: snd_music_easy,
            drop_chance: 0.10, max_drops: 1, items: [Item.POTION], tricks: false
        },
        {
            name: "MEDIUM", pairs: 9, columns: 6, seconds: 75, reveal: 0.6, peek: 2, penalty: 0, music: snd_music_medium,
            drop_chance: 0.15, max_drops: 2, items: [Item.POTION, Item.BRAIN], tricks: false
        },
        {
            name: "HARD", pairs: 12, columns: 6, seconds: 60, reveal: 0.5, peek: 0, penalty: 0, music: snd_music_hard,
            drop_chance: 0.20, max_drops: 2, items: [Item.POTION, Item.BRAIN, Item.SCARAB, Item.ANKH], tricks: false
        },
        {
            name: "NIGHTMARE", pairs: 12, columns: 6, seconds: 45, reveal: 0.35, peek: 0, penalty: 2, music: snd_music_nightmare,
            drop_chance: 0.25, max_drops: 3, items: [Item.POTION, Item.BRAIN, Item.SCARAB, Item.ANKH, Item.BASKET], tricks: true
        }
    ];

    return _settings[_difficulty];
}

/// @function difficulty_summary(_difficulty)
/// @description Short line for the difficulty menu, e.g. "6 pairs - 90 sec - peek".
/// @param {Real} _difficulty  A Difficulty value.
/// @returns {String}
function difficulty_summary(_difficulty)
{
    var _rules = difficulty_settings(_difficulty);
    var _text  = string(_rules.pairs) + " pairs - " + string(_rules.seconds) + " sec";

    if (_rules.peek > 0)
    {
        _text += " - peek";
    }

    if (_rules.penalty > 0)
    {
        _text += " - misses cost " + string(_rules.penalty) + "s";
    }

    return _text;
}

/// @function monster_faces()
/// @description Returns all 12 monster sprites in a random order.
/// @returns {Array<Asset.GMSprite>}
function monster_faces()
{
    var _faces =
    [
        spr_bigfootcard, spr_draculacard, spr_frankcard,  spr_mummycard,
        spr_mermancard,  spr_cyclopscard, spr_demoncard,  spr_aliencard,
        spr_robotcard,   spr_skellycard,  spr_wolfmancard, spr_zombiecard
    ];

    array_shuffle_ext(_faces);
    return _faces;
}

/// @function item_sprite(_item)
/// @description Returns the sprite for an Item value.
/// @param {Real} _item  An Item value.
/// @returns {Asset.GMSprite}
function item_sprite(_item)
{
    static _sprites = [spr_item_potion, spr_item_brain, spr_item_scarab, spr_item_ankh, spr_item_basket];
    return _sprites[_item];
}
