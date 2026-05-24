// apply gravity and move
vspeed += gravity;
// apply movement
x += hspeed;
y += vspeed;

// collision with world
if (place_meeting(x, y, Obj_colisor)) {
    // create simple impact effect (if desired), then destroy
    instance_destroy();
}

// hit player
var _pl = instance_place(x, y, oPlayerMilitar);
if (_pl != noone) {
    if (variable_instance_exists(_pl, "TakeDamage")) {
        _pl.TakeDamage(damage);
    } else if (variable_global_exists("player_hp")) {
        global.player_hp = max(0, global.player_hp - damage);
        show_debug_message("Player took " + string(damage) + " damage. HP: " + string(global.player_hp));
        if (global.player_hp <= 0) {
            // basic player death
            if (instance_exists(_pl)) instance_destroy(_pl);
        }
    }
    instance_destroy();
}
