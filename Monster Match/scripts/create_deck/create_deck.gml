/// @function create_deck(_deck, _pair_count)
/// @description Creates two card instances for every monster and stores them in the deck.
///              Cards start hidden; shuffle_cards() lays them out at the start of each round.
/// @param {Id.DsList} _deck        Empty list that will hold the card instances.
/// @param {Real}      _pair_count  How many matching pairs to create.
function create_deck(_deck, _pair_count)
{
    for (var _pair = 0; _pair < _pair_count; _pair++)
    {
        repeat (2)
        {
            var _card = instance_create_layer(0, 0, CARD_LAYER, obj_card);
            _card.pair_id = _pair;
            _card.visible = false;
            ds_list_add(_deck, _card);
        }
    }
}
