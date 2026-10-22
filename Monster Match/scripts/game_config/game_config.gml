// Game settings

enum GameState
{
    PAUSED,   // input locked (deck not dealt yet, or a pair is being shown)
    PLAYING,  // player can turn cards over
    WON,      // every pair found before time ran out
    LOST      // time ran out
}

#region Round rules
#macro PAIR_COUNT          12     // pairs on the table (24 cards)
#macro PLAY_TIME_SECONDS   60     // length of a round; matches snd_game_music
#macro PAIR_REVEAL_SECONDS 0.5    // how long two picked cards stay face up
#macro RESTART_DELAY_MS    750    // stops a frantic last click from instantly restarting
#endregion

#region obj_controller alarm slots
#macro ALARM_ROUND_TIMER   0
#macro ALARM_PAIR_CHECK    1
#endregion

#region Table layout
// Card sprites are 100x150 with a centred origin
#macro CARD_LAYER          "Instances"
#macro CARDS_PER_ROW       6
#macro CARD_START_X        125    // centres the 6 columns in the 800px room
#macro CARD_START_Y        160
#macro CARD_SPACING_X      110
#macro CARD_SPACING_Y      160
#endregion

#region HUD layout
#macro TEXT_SHADOW_OFFSET  3
#macro TIMER_Y             13
#macro BANNER_TOP          330
#macro BANNER_BOTTOM       470
#macro BANNER_TITLE_Y      380
#macro BANNER_PROMPT_Y     440
#endregion

/// @function card_face_sprite(_pair_id)
/// @description Returns the monster sprite for a pair id (0 to 11).
/// @param {Real} _pair_id  Which monster the card shows.
/// @returns {Asset.GMSprite}
function card_face_sprite(_pair_id)
{
    static _faces =
    [
        spr_bigfootcard, spr_draculacard, spr_frankcard,  spr_mummycard,
        spr_mermancard,  spr_cyclopscard, spr_demoncard,  spr_aliencard,
        spr_robotcard,   spr_skellycard,  spr_wolfmancard, spr_zombiecard
    ];

    return _faces[_pair_id];
}
