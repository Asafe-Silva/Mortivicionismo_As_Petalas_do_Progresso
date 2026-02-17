// --- Step Event Refactored ---
if (variable_global_exists("game_paused") && global.game_paused) {
    image_speed = 0; // Freeze animation if using sprite-based animation
    exit; // Stop processing movement/combat
} else {
    // Resume animation (basic logic, might need refining based on state)
    // image_speed = 1; // Commented out to let ProcessAnimation handle it naturally,
    // or set it to 1 if default for moving.
    // Given ProcessAnimation sets image_speed based on state, we might just need to ensure it's not 0 IF we are supposed to be moving.
    // For now, let's just let the loop continue.
}

ProcessInteraction();
ProcessInput();
ProcessMovement();
ProcessAnimation();
ProcessCamera();
ProcessCombat();


