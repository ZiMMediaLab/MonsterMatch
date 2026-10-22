/// @description Free the deck list and stop the round's sounds when leaving the room
ds_list_destroy(deck);
audio_stop_sound(rules.music);
audio_stop_sound(snd_evil_laugh);
