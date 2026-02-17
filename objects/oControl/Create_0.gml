// --- Game Logic Initialization ---
// Ensures global variables persist across rooms.

if (!variable_global_exists("game_initialized") || !global.game_initialized) {
    // 1. Dialogue System
    global.dialogo = false;
    global.dialogo_lock = false;

    // 2. Legacy Inventory (DS List)
    if (!variable_global_exists("inv")) global.inv = ds_list_create();
    if (!variable_global_exists("inv_peso_atual")) global.inv_peso_atual = 0;
    if (!variable_global_exists("inv_peso_max")) global.inv_peso_max = 40;

    // 3. Sanity (Trauma) System
    if (!variable_global_exists("sanidade_atual")) global.sanidade_atual = 100;
    if (!variable_global_exists("sanidade_max")) global.sanidade_max = 100;
    if (!variable_global_exists("low_sanity")) global.low_sanity = false;

    // Function to safely modify Sanity
    global.ModifySanity = function(_amount) {
        global.sanidade_atual = clamp(global.sanidade_atual + _amount, 0, global.sanidade_max);
        
        // Low Sanity Flag (< 20%)
        global.low_sanity = (global.sanidade_atual <= (global.sanidade_max * 0.2));
        
        show_debug_message("Sanity: " + string(global.sanidade_atual) + "/" + string(global.sanidade_max));
    }

    // 4. Traumas Map
    if (!variable_global_exists("traumas")) global.traumas = ds_map_create();

    // 5. Weapon State (Walther P38)
    if (!variable_global_exists("have_walther")) global.have_walther = false;
    if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = 6;
    if (!variable_global_exists("walther_ammo")) global.walther_ammo = global.walther_max_ammo;
    if (!variable_global_exists("walther_cooldown")) global.walther_cooldown = 0;

    global.game_initialized = true;
}

// --- Managers Initialization ---
if (!instance_exists(oInventoryManager)) {
    instance_create_depth(0, 0, 0, oInventoryManager);
}

if (!instance_exists(oInventoryUI)) {
    instance_create_depth(0, 0, -100, oInventoryUI);
}

init_item_definitions();