// Obj_GameState - Create
// Centraliza inicialização de globals do jogo
// garante que esta instância persista entre rooms
persistent = true;
if (!variable_global_exists("game_initialized") || !global.game_initialized) {
    // Diálogo
    global.dialogo = false;
    global.dialogo_lock = false;

    // Inventário
    if (!variable_global_exists("inv")) global.inv = ds_list_create();
    if (!variable_global_exists("inv_peso_atual")) global.inv_peso_atual = 0;
    if (!variable_global_exists("inv_peso_max")) global.inv_peso_max = 40;

    // Sanidade
    if (!variable_global_exists("sanidade_atual")) global.sanidade_atual = 100;
    if (!variable_global_exists("sanidade_max")) global.sanidade_max = 100;

    // Traumas
    if (!variable_global_exists("traumas")) global.traumas = ds_map_create();

    // Arma Walther
    if (!variable_global_exists("have_walther")) global.have_walther = false;
    if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = 6;
    if (!variable_global_exists("walther_ammo")) global.walther_ammo = global.walther_max_ammo;
    if (!variable_global_exists("walther_cooldown")) global.walther_cooldown = 0;

    global.game_initialized = true;
}
