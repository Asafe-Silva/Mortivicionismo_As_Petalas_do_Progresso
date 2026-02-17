// Step: verifica vida e colisão
life -= 1;
if (life <= 0) instance_destroy();

if (place_meeting(x, y, Obj_colisor)) {
    // opcional: criar efeito
    instance_destroy();
}
