// Step: comportamento básico de perseguição com colisão
var _player = instance_nearest(x, y, oPlayerMilitar);
if (_player != noone) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    // se ver o jogador (alcance de visão)
    if (_dist < vision_range) {
        var _dir = point_direction(x, y, _player.x, _player.y);
        var _speed = 1.2;
        var _dx = lengthdir_x(_speed, _dir);
        var _dy = lengthdir_y(_speed, _dir);

        // movimento com colisão simples (x then y)
        if (!place_meeting(x + _dx, y, Obj_colisor)) {
            x += _dx;
        } else {
            var _step = sign(_dx);
            while (_step != 0 && !place_meeting(x + _step, y, Obj_colisor)) {
                x += _step;
                break;
            }
        }

        if (!place_meeting(x, y + _dy, Obj_colisor)) {
            y += _dy;
        } else {
            var _stepy = sign(_dy);
            while (_stepy != 0 && !place_meeting(x, y + _stepy, Obj_colisor)) {
                y += _stepy;
                break;
            }
        }
    }
}

// pickup fish from nearest box (only enemies should pick)
if (pick_cooldown > 0) pick_cooldown -= 1;
if (throw_cooldown > 0) throw_cooldown -= 1;

var _box = instance_nearest(x, y, Obj_caixa_de_peixes_vivos);
if (_box != noone) {
    var _d2 = point_distance(x, y, _box.x, _box.y);
    if (_d2 <= 20 && pick_cooldown <= 0) {
        // pick one fish (infinite box)
        fish_count += 1;
        pick_cooldown = 30;
        // play pick animation in reverse if available
        if (image_number > 1) {
            image_index = image_number - 1;
            image_speed = -1;
        }
        show_debug_message("Enemy picked a fish; now has: " + string(fish_count));
    }
}

// throw fish at player if has fish
if (fish_count > 0 && _player != noone && point_distance(x, y, _player.x, _player.y) <= attack_range && throw_cooldown <= 0) {
    // create projectile with arc: initial speed and gravity handled in projectile Step
    var _dirt = point_direction(x, y, _player.x, _player.y);
    var _spd = 6 + irandom(2);
    var _proj = instance_create_layer(x, y - 8, "Instances", Obj_peixe_proj);
    with (_proj) {
        // set velocity from direction
        hspeed = lengthdir_x(_spd, _dirt);
        vspeed = lengthdir_y(_spd, _dirt) - 4; // give an upward bias for arc
        owner = other.id;
    }
    fish_count -= 1;
    throw_cooldown = 60 + irandom(30);
    // play throw animation forward
    if (image_number > 1) {
        image_index = 0;
        image_speed = 1;
    }
}

// vida baixa => destroy
if (variable_local_exists("hp") && hp <= 0) {
    instance_destroy();
}
