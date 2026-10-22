/// @description Bob in place, then disappear if nobody grabs it
var _age = current_time - spawn_time;

if (_age >= ITEM_LIFETIME_MS)
{
    instance_destroy();
    exit;
}

y = base_y + sin(_age / 180) * 4;
