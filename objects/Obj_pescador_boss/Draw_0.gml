// Este seria o sprite, mas como estamos trabalhando apenas com código, presumimos que o usuário atribua um ou que usemos um evento de desenho de espaço reservado.
draw_self();
draw_healthbar(x-32, y-62, x+30, y-68, (hp/max_hp)*100, c_black, c_red, c_green, 0, true, true);