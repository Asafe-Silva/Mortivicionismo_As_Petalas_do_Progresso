// Step: movimenta cartucho e permite pickup automático ao se aproximar do jogador
x += hspeed; y += vspeed;
vspeed += 0.1; // leve gravidade
life -= 1;
if (life <= 0) instance_destroy();

var p = instance_nearest(x, y, Obj_prota_militar);
if (instance_exists(p) && point_distance(x, y, p.x, p.y) <= 18) {
    // cria item e adiciona ao inventário
    var item = ds_map_create();
    ds_map_add(item, "name", "Cartucho Walther P38");
    ds_map_add(item, "peso", 0.1);
    ds_map_add(item, "valor_emocional", 0);
    ds_map_add(item, "corrompido", false);
    ds_map_add(item, "origem_violenta", false);
    ds_map_add(item, "trauma_associado", "");
    scr_item_add(item);
    // destrói o map local para evitar vazamento
    ds_map_destroy(item);
    instance_destroy();
}
