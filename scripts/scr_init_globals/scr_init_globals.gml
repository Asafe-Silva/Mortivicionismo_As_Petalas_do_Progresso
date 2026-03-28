/// @function InitGlobals()
/// @description Initializes all global variables required for the game structure.
/// This can be called multiple times safely, as it uses variable_global_exists.
function InitGlobals() {
    if (!variable_global_exists("game_initialized") || !global.game_initialized) {
        // 1. Dialogue System
        if (!variable_global_exists("dialogo")) global.dialogo = false;
        if (!variable_global_exists("dialogo_lock")) global.dialogo_lock = false;

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
        
        // 6. Gameplay State
        if (!variable_global_exists("game_paused")) global.game_paused = false;
        if (!variable_global_exists("player_hp")) global.player_hp = 100;
        if (!variable_global_exists("is_loading_game")) global.is_loading_game = false;

        global.game_initialized = true;
        show_debug_message("Globals Initialized.");
    }
    
    // 7. Ensure system objects exist (Critical for loading from title screen)
    if (!instance_exists(oControl)) {
        show_debug_message("System oControl missing. Creating...");
        instance_create_depth(0, 0, 0, oControl);
    }
}

/// @function ResetGameSession()
/// @description Resets all gameplay-related global variables to their default values.
/// Useful for starting a new game or returning to the title screen.
function ResetGameSession() {
    InitGlobals(); // Ensure they are at least initialized
    
    // Reset stats
    global.sanidade_atual = 100;
    global.player_hp = 100;
    global.dialogo = false;
    global.game_paused = false;
    
    // Clear data structures
    if (variable_global_exists("inv")) ds_list_clear(global.inv);
    if (variable_global_exists("traumas")) ds_map_clear(global.traumas);
    
    // Reset weapon
    global.have_walther = false;
    global.walther_ammo = global.walther_max_ammo;
    
    show_debug_message("Game Session Reset to Defaults.");
}
