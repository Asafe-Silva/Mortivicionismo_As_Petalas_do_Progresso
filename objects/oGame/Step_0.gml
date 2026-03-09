/// @description Global Logic (Pause, Menus)

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
