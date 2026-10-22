/// @function create_menu_button(_x, _y, _label, _on_click)
/// @description Creates a clickable text button on the Instances layer.
/// @param {Real}     _x         Centre x.
/// @param {Real}     _y         Centre y.
/// @param {String}   _label     Button text.
/// @param {Function} _on_click  Runs when the button is clicked or tapped.
/// @returns {Id.Instance}
function create_menu_button(_x, _y, _label, _on_click)
{
    var _button = instance_create_layer(_x, _y, CARD_LAYER, obj_menu_button);
    _button.label    = _label;
    _button.on_click = _on_click;

    return _button;
}
