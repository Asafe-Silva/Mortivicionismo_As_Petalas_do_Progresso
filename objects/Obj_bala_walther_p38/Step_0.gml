// Step: movimenta projétil, detecta colisão com colisor e decrementa vida
x += lengthdir_x(speed, dir);
y += lengthdir_y(speed, dir);
life -= 1;
if (life <= 0) instance_destroy();

if (place_meeting(x, y, Obj_colisor)) {
    // opcional: criar efeito
    instance_destroy();
}
