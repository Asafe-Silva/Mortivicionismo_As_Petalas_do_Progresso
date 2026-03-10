/// @description Global Logic (Pause, Menus, HUD)

// HUD Interpolation
if (variable_global_exists("player_hp")) {
    hp_lerp = lerp(hp_lerp, global.player_hp, 0.1);
}
if (variable_global_exists("sanidade_atual")) {
    sanity_lerp = lerp(sanity_lerp, global.sanidade_atual, 0.1);
}

// Toggle Inventory / Pause
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
    // Check if oInventoryManager exists
    if (instance_exists(oInventoryManager)) {
        oInventoryManager.menuActive = !oInventoryManager.menuActive;
        global.game_paused = oInventoryManager.menuActive;
        
        // UX: Reset hover when closing
        if (!oInventoryManager.menuActive) {
            if (instance_exists(oInventoryUI)) {
                oInventoryUI.hovered_slot = -1;
            }
        }
    }
}

// Temporary Save/Load Triggers
if (keyboard_check_pressed(vk_f5)) {
    SaveGame();
}

if (keyboard_check_pressed(vk_f6)) {
    LoadGame();
}
