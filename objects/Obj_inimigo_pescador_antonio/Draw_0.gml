// Este seria o sprite, mas como estamos trabalhando apenas com código, presumimos que o usuário atribua um ou que usemos um evento de desenho de espaço reservado.
draw_self();
draw_healthbar(x-15, y-32, x+15, y-40, (hp/max_hp)*100, c_black, c_red, c_green, 0, true, true);
