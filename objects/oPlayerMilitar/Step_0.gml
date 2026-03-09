// --- Step Event Refactored ---
if (variable_global_exists("game_paused") && global.game_paused) {
    image_speed = 0; // Freeze animation if using sprite-based animation
    exit; // Stop processing movement/combat
}

// Execute State Machine
ProcessState();

// Process Camera always (or inside states if needed)
ProcessCamera();


