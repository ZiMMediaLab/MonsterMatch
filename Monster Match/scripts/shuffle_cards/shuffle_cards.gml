/// @function shuffle_cards(_deck)
/// @description Shuffles the deck, lays every card out in a grid,
///              and resets each card to face down and unmatched.
/// @param {Id.DsList} _deck  The list of card instances.
function shuffle_cards(_deck)
{
    ds_list_shuffle(_deck);

    var _card_count = ds_list_size(_deck);

    for (var _i = 0; _i < _card_count; _i++)
    {
        var _card   = _deck[| _i];
        var _column = _i mod CARDS_PER_ROW;
        var _row    = _i div CARDS_PER_ROW;

        _card.x = CARD_START_X + (_column * CARD_SPACING_X);
        _card.y = CARD_START_Y + (_row * CARD_SPACING_Y);

        _card.is_face_up = false;
        _card.is_matched = false;
        _card.visible    = true;
    }
}
