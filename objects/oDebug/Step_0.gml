/// @description Debug Controls

// Sanity
// Decrease Sanity (Trauma) - Key K
if (keyboard_check_pressed(ord("K"))) {
    if (variable_global_exists("ModifySanity")) {
        global.ModifySanity(-10);
    }
}

// Increase Sanity - Key L
if (keyboard_check_pressed(ord("L"))) {
    if (variable_global_exists("ModifySanity")) {
        global.ModifySanity(10);
    }
}