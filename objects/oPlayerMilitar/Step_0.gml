// --- Step Event Refactored ---
if (variable_global_exists("game_paused") && global.game_paused) {
    image_speed = 0; // Freeze animation if using sprite-based animation
    exit; // Stop processing movement/combat
}

// Coordinate loading fix
if (variable_global_exists("is_loading_game") && global.is_loading_game) {
    x = global.load_target_x;
    y = global.load_target_y;
    global.is_loading_game = false;
}

// Execute State Machine
ProcessState();

// Process Camera always (or inside states if needed)
ProcessCamera();


