/// @description Big Brain is over - turn the cards back over
if (global.game_state == GameState.PAUSED)
{
    cover_all_cards(deck);
    global.game_state = GameState.PLAYING;
}
