// Step: verifica vida e colisão
life -= 1;
if (life <= 0) instance_destroy();

if (place_meeting(x, y, Obj_colisor)) {
    // opcional: criar efeito
    instance_destroy();
}

// colisão com inimigos (parent or test enemy)
var _hit = instance_place(x, y, Obj_par_inimigos);
if (_hit != noone) {
    if (variable_instance_exists(_hit, "TakeDamage")) {
        _hit.TakeDamage(damage);
    } else if (variable_instance_exists(_hit, "hp")) {
        with (_hit) {
            hp -= damage;
            if (hp <= 0) instance_destroy();
        }
    }
    instance_destroy();
}

var _hit2 = instance_place(x, y, Obj_InimigoTeste);
if (_hit2 != noone) {
    if (variable_instance_exists(_hit2, "TakeDamage")) {
        _hit2.TakeDamage(damage);
    } else if (variable_instance_exists(_hit2, "hp")) {
        with (_hit2) {
            hp -= damage;
            if (hp <= 0) instance_destroy();
        }
    }
    instance_destroy();
}
