// =========================
// VIDA
// =========================

life -= 1;

if (life <= 0)
{
    instance_destroy();
}



// =========================
// COLISÃO COM PAREDE
// =========================

if (place_meeting(x, y, Obj_colisor)){
    instance_destroy();
}



// =========================
// COLISÃO COM INIMIGO
// =========================

var inimigo = instance_place(x, y, Obj_par_inimigos);

if (inimigo != noone){
    inimigo.hp -= 20;

    if (inimigo.hp <= 0){
        instance_destroy(inimigo);
    }

    instance_destroy();
}
