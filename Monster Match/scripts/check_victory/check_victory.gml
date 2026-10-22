/// @function check_victory(_deck)
/// @description Checks whether every pair has been found.
/// @param {Id.DsList} _deck  The list of card instances.
/// @returns {Bool} True when no unmatched cards are left.
function check_victory(_deck)
{
    var _card_count = ds_list_size(_deck);

    for (var _i = 0; _i < _card_count; _i++)
    {
        if (!_deck[| _i].is_matched)
        {
            return false;
        }
    }

    return true;
}
