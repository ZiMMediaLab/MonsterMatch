/// @function reveal_all_cards(_deck)
/// @description Turns every card face up (used to show the board when time runs out).
///              Matched cards stay hidden because they are no longer visible.
/// @param {Id.DsList} _deck  The list of card instances.
function reveal_all_cards(_deck)
{
    var _card_count = ds_list_size(_deck);

    for (var _i = 0; _i < _card_count; _i++)
    {
        _deck[| _i].is_face_up = true;
    }
}
