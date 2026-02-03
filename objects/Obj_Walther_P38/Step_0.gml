// Obj_Walther_P38 - Step

// Pickup: jogador se aproxima e pressiona E -> pega arma
var p = instance_nearest(x, y, Obj_prota_militar);
if (instance_exists(p) && point_distance(x, y, p.x, p.y) <= pickup_range) {
    if (keyboard_check_pressed(ord("E"))) {
        global.have_walther = true;
        global.walther_ammo = global.walther_max_ammo;
        instance_destroy();
    }
}
