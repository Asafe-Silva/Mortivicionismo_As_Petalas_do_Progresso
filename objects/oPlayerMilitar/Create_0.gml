
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



// --- State Machine ---
enum PLAYER_STATE {
    FREE,
    ATTACK
}
state = PLAYER_STATE.FREE;

// --- Methods ---

/// @function StateFree()
StateFree = function() {
    ProcessInput();
    ProcessMovement();
    ProcessAnimation();
    ProcessInteraction();
    ProcessCombat(); // Keeps gun logic working for now
    
    // Check for Melee Attack (Space or Right Click?)
    if (keyboard_check_pressed(vk_space)) {
        state = PLAYER_STATE.ATTACK;
        image_index = 0;
        image_speed = 1;
        // Logic to stop movement is handled by not calling ProcessMovement
    }
}

/// @function StateAttack()
StateAttack = function() {
    // Stop movement
    hSpeed = 0;
    vSpeed = 0;
    
    // Create Hitbox on first frame (or specific frame)
    if (floor(image_index) == 1) { 
       if (!instance_exists(oHitbox)) { 
           // Calculate offset based on last input direction (approximated from sprites if needed, but using saved direction is better)
           // If we don't have a specific `facingVector`, we can derive it:
           var _offX = 0;
           var _offY = 0;
           
           if (lastAxisMoved == "x") {
               _offX = facingDirection * 20;
           } else {
               // Determine up/down based on sprite or stored state
               // Since we don't store "lastYDir", we can look at the sprite or input if still held
               // But state machine stops movement, so input might be zero.
               // Let's assume Down if unknown, or check current sprite.
               if (sprite_index == Spr_prota_cima_militar) {
                   _offY = -20;
               } else {
                   _offY = 20; // Default down
               }
           }
           
           var _hitbox = instance_create_layer(x + _offX, y + _offY, "Instances", oHitbox);
           _hitbox.owner = id;
            
            // A barra de espaço é estritamente um ataque corpo-a-corpo.
            _hitbox.damage = 5; 
        }
    }

    // End Attack
    // For now, using a simple timer or animation end check
    // If no specific attack sprite, we simulate with timer or just use a color blink
    
    // Placeholder animation check:
    // if (image_index >= image_number - 1) {
    //    state = PLAYER_STATE.FREE;
    // }
    
    // Since we don't have a specific attack sprite yet, let's use a timer approach for prototype
    if (alarm[0] <= 0) {
        alarm[0] = 20; // 20 frames attack duration
        // Visual debug
        image_blend = c_red; 
    }
}

/// @function ProcessState()
ProcessState = function() {
    switch (state) {
        case PLAYER_STATE.FREE:
            StateFree();
            break;
        case PLAYER_STATE.ATTACK:
            StateAttack();
            break;
    }
}

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
        facingDirection = -inputDirection[0]; 
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

    // Firearms Logic (Check Equipped Weapon)
    var _has_firearm = false;
    if (variable_global_exists("arma_equipada") && global.arma_equipada != undefined) {
        // Only allow shooting if the equipped weapon is a firearm (e.g. "pistol")
        if (variable_struct_exists(global.arma_equipada, "id") && global.arma_equipada.id == "pistol") {
            _has_firearm = true;
        }
    }

    if (_has_firearm) {
        
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
                var _bullet = instance_create_layer(x, y - 8, "Instances", Obj_bala_walther_p38); // Assuming layer

                with (_bullet) {
                    direction = _dir;
                    image_angle = _dir;
                    speed = 12;
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
    //for (var i = 0; i < 6; i++) {
    //    var _cartridge = instance_create_depth(x + random_range(-8, 8), y + random_range(-8, 8), 0, Obj_cartucho_walther_p38);
    //    with (_cartridge) {
    //        hspeed = random_range(-2, 2);
    //        vspeed = random_range(-2, 2);
    //    }
    //}
}
