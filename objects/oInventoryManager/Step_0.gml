
// Input handling for Menu
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
    menuActive = !menuActive;
    global.game_paused = menuActive;
    
    // UX: Reset hover when closing
    if (!menuActive) {
        if (instance_exists(oInventoryUI)) {
            oInventoryUI.hovered_slot = -1;
        }
    }
}
