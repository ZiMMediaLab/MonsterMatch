/// @description Click or tap after a round ends to play again
// Released (not pressed) so the same click can't also flip a card.
// Clicks on the Back button are left to the button.
if (can_restart() && !back_button.is_hovered())
{
    start_round();
}
