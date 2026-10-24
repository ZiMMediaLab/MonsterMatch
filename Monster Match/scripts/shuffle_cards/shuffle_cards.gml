/// @function shuffle_cards(_deck, _columns)
/// @description Shuffles the deck, gives each pair a random monster, lays the cards out
///              in a grid centred on the table, and resets each card to face down and unmatched
///              (and clears any scarab glow left from the last round).
/// @param {Id.DsList} _deck     The list of card instances.
/// @param {Real}      _columns  Cards per row.
function shuffle_cards(_deck, _columns)
{
    ds_list_shuffle(_deck);

    var _faces      = monster_faces();
    var _card_count = ds_list_size(_deck);
    var _rows       = ceil(_card_count / _columns);
    var _start_x    = GRID_CENTRE_X - ((_columns - 1) * CARD_SPACING_X) / 2;
    var _start_y    = GRID_CENTRE_Y - ((_rows - 1) * CARD_SPACING_Y) / 2;

    for (var _i = 0; _i < _card_count; _i++)
    {
        var _card   = _deck[| _i];
        var _column = _i mod _columns;
        var _row    = _i div _columns;

        _card.x = _start_x + (_column * CARD_SPACING_X);
        _card.y = _start_y + (_row * CARD_SPACING_Y);

        _card.face_sprite = _faces[_card.pair_id];
        _card.is_face_up  = false;
        _card.is_matched  = false;
        _card.visible     = true;

        _card.glow_until   = 0;
        _card.scarab_until = 0;
    }
}
