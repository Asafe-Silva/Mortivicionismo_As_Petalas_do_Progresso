
// --- Internal State ---

// Movement
moveSpeed = 2;
hSpeed = 0;
vSpeed = 0;
velocity = [0, 0]; // x, y
inputDirection = [0, 0]; // x, y
isMoving = false;

// Interaction
facingDirection = 1; // 1 = right, -1 = left . Maps to image_xscale
lastAxisMoved = "y"; // "x" or "y"

// Camera
camZoom = 1;
camTargetZoom = 1;
camSpeed = 0.05;
camera = view_camera[0];
// Cache camera dimensions (update if resolution changes dynamically)
camWidth = camera_get_view_width(camera);
camHeight = camera_get_view_height(camera);

// Combat (Walther P38) state - local tracking for simplicity
// ideally this should be in a Weapon struct/object, but keeping as is for now with better naming
waltherCooldownTimer = 0;


// --- Methods ---

/// @function ProcessInput()
ProcessInput = function() {
    // Return early if dialogue is open
    if (global.dialogo) {
        inputDirection = [0, 0];
        isMoving = false;
        return;
    }

    var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _up = keyboard_check(vk_up) || keyboard_check(ord("W"));
    var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));

    inputDirection[0] = _right - _left;
    inputDirection[1] = _down - _up;

    isMoving = (inputDirection[0] != 0 || inputDirection[1] != 0);
}

/// @function ProcessMovement()
ProcessMovement = function() {
    // 1. Calculate Speed based on Weight
    var _weightCurrent = variable_global_exists("inv_peso_atual") ? global.inv_peso_atual : 0;
    var _weightMax = variable_global_exists("inv_peso_max") ? global.inv_peso_max : 40;
    
    // Avoid division by zero
    var _ratio = (_weightMax > 0) ? (_weightCurrent / _weightMax) : 0;

    if (_ratio < 0.5) {
        moveSpeed = 2;
    } else if (_ratio < 0.8) {
        moveSpeed = 1.5;
    } else {
        moveSpeed = 1;
    }

    // 2. Apply Velocity
    hSpeed = inputDirection[0] * moveSpeed;
    vSpeed = inputDirection[1] * moveSpeed;

    // 3. Horizontal Collision
    if (place_meeting(x + hSpeed, y, Obj_colisor)) {
        var _step = sign(hSpeed);
        while (!place_meeting(x + _step, y, Obj_colisor)) {
            x += _step;
        }
        hSpeed = 0;
    }
    x += hSpeed;

    // 4. Vertical Collision
    if (place_meeting(x, y + vSpeed, Obj_colisor)) {
        var _step = sign(vSpeed);
        while (!place_meeting(x, y + _step, Obj_colisor)) {
            y += _step;
        }
        vSpeed = 0;
    }
    y += vSpeed;
}

/// @function ProcessAnimation()
ProcessAnimation = function() {
    // Update facing direction
    if (inputDirection[0] != 0) {
        facingDirection = -inputDirection[0]; // -1 for right input (check existing logic), 1 for left
        // Note: original code: move_x == -1 (left) -> olhar = 1 ; move_x == 1 (right) -> olhar = -1
        // So: inputDirection[0] = -1 (left) -> facing = 1. inputDirection[0] = 1 (right) -> facing = -1.
        // Formula: facing = -inputDirection[0] matches.
        
        lastAxisMoved = "x";
    } else if (inputDirection[1] != 0) {
        lastAxisMoved = "y";
    }

    // Update sprites
    if (!isMoving) {
        sprite_index = Spr_prota_parado_militar;
        image_speed = 0;
        image_index = 0; 
        image_xscale = facingDirection;
    } else {
        if (lastAxisMoved == "x") {
            sprite_index = Spr_prota_corendo_militar;
            image_speed = 1;
            image_xscale = facingDirection;
        } else {
            // Moving vertically
            if (inputDirection[1] < 0) { // Up
                sprite_index = Spr_prota_cima_militar;
                image_speed = 1;
            } else if (inputDirection[1] > 0) { // Down
                sprite_index = Spr_prota_baixo_militar;
                image_speed = 1;
            }
            // Inherit xscale from last horizontal move effectively
             image_xscale = facingDirection; 
        }
    }
}

/// @function ProcessInteraction()
ProcessInteraction = function() {
     // Safety checks for globals
    if (!variable_global_exists("dialogo")) global.dialogo = false;
    if (!variable_global_exists("dialogo_lock")) global.dialogo_lock = false;

    if (global.dialogo) return;

    // Unlock dialogue lock when E is released
    if (!keyboard_check(ord("E"))) {
        global.dialogo_lock = false;
    }

    if (!global.dialogo_lock) {
        var _npc = instance_nearest(x, y, Obj_par_npcs);
        if (_npc != noone && distance_to_object(_npc) <= 10) {
            if (keyboard_check_pressed(ord("E"))) {
                var _dialogBox = instance_create_layer(x, y, "dialogo", Obj_dialogo);
                _dialogBox.npc_nome = _npc.nome;
                
                global.dialogo = true;
                global.dialogo_lock = true;
            }
        }
    }
}

/// @function ProcessCamera()
ProcessCamera = function() {
    var _camX = x - (camWidth / 2);
    var _camY = y - (camHeight / 2);

    var _smooth = 0.1;
    var _newX = lerp(camera_get_view_x(camera), _camX, _smooth);
    var _newY = lerp(camera_get_view_y(camera), _camY, _smooth);

    camera_set_view_pos(camera, _newX, _newY);

    // Zoom
    camZoom = lerp(camZoom, camTargetZoom, camSpeed);
    var _newW = camWidth / camZoom;
    var _newH = camHeight / camZoom;
    camera_set_view_size(camera, _newW, _newH);
}

/// @function ProcessCombat()
ProcessCombat = function() {
    // Sanity effects (placeholders for now)
    if (variable_global_exists("sanidade_atual")) {
        if (global.sanidade_atual <= 40) { /* Tremor */ }
        if (global.sanidade_atual <= 20) { /* Vision */ }
    }

    // Walther P38 Logic
    if (variable_global_exists("have_walther") && global.have_walther) {
        
        // Ensure globals exist
        if (!variable_global_exists("walther_ammo")) global.walther_ammo = 6;
        if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = 6;
        if (!variable_global_exists("walther_cooldown")) global.walther_cooldown = 0;

        // Cooldown
        if (global.walther_cooldown > 0) global.walther_cooldown--;

        // Shooting
        if (mouse_check_button_pressed(mb_left) && global.walther_cooldown <= 0) {
            if (global.walther_ammo > 0) {
                var _dir = point_direction(x, y, mouse_x, mouse_y);
                var _bullet = instance_create_layer(x, y, "Instances", Obj_bala_walther_p38); // Assuming layer
                // If Obj_bala_walther_p38 is not created via instance_create_layer due to GMS version, use instance_create_depth
                 if (!instance_exists(_bullet)) _bullet = instance_create_depth(x, y, 0, Obj_bala_walther_p38);

                with (_bullet) {
                    dir = _dir;
                    speed = 12; // Should be bulletSpeed
                    life = 60;
                }
                
                global.walther_ammo--;
                global.walther_cooldown = 12;
            } else {
                // Auto-Reload (Eject cartridges)
                RepeatReloadAction();
                global.walther_ammo = global.walther_max_ammo;
            }
        }

        // Manual Reload
        if (keyboard_check_pressed(ord("R"))) {
             RepeatReloadAction();
             global.walther_ammo = global.walther_max_ammo;
        }
    }
}

/// @function RepeatReloadAction()
RepeatReloadAction = function() {
    for (var i = 0; i < 6; i++) {
        var _cartridge = instance_create_depth(x + random_range(-8, 8), y + random_range(-8, 8), 0, Obj_cartucho_walther_p38);
        with (_cartridge) {
            hspeed = random_range(-2, 2);
            vspeed = random_range(-2, 2);
        }
    }
}
