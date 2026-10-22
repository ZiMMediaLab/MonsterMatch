/// @function cover_all_cards(_deck)
/// @description Turns every card face down.
/// @param {Id.DsList} _deck  The list of card instances.
function cover_all_cards(_deck)
{
    var _card_count = ds_list_size(_deck);

    for (var _i = 0; _i < _card_count; _i++)
    {
        _deck[| _i].is_face_up = false;
    }
}
