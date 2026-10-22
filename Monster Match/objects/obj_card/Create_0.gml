/// @description Card defaults (create_deck and shuffle_cards fill in the real values)
pair_id     = -1;             // both cards in a pair share this
face_sprite = spr_cardback;   // the monster this pair shows this round
is_face_up  = false;
is_matched  = false;          // matched cards are hidden for the rest of the round

glow_until   = 0;             // current_time (ms) the scarab glow ends
scarab_until = 0;             // current_time (ms) the scarab leaves this card

sprite_index = spr_cardback;
