// procura inimigos próximos para dar peixe (infinito)
var _enemy = instance_nearest(x, y, Obj_InimigoTeste);
if (_enemy != noone) {
    var _d = point_distance(x, y, _enemy.x, _enemy.y);
    if (_d <= pickupRange) {
        if (variable_local_exists("pick_cooldown") && _enemy.pick_cooldown <= 0) {
            // enemy will pick in its own step, but we can nudge it
            _enemy.pick_cooldown = 0; // allow immediate pick
        }
    }
}
