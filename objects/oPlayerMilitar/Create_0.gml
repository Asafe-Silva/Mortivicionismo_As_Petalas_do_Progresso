
// --- Estado Interno ---

// Movimento
moveSpeed = 2;
hSpeed = 0;
vSpeed = 0;
velocity = [0, 0]; // x, y
inputDirection = [0, 0]; // x, y
isMoving = false;

// Interação
facingDirection = 1; // 1 = right, -1 = left . Maps to image_xscale
lastAxisMoved = "y"; // "x" or "y"

// Câmera
camZoom = 1;
camTargetZoom = 1;
camSpeed = 0.05;
camera = view_camera[0];
// Armazenar em cache as dimensões da câmera (atualizar se a resolução mudar dinamicamente)
camWidth = camera_get_view_width(camera);
camHeight = camera_get_view_height(camera);

// Estado de Combate (Walther P38) - controle local por simplicidade
// idealmente isso deveria estar em uma struct `Weapon`, mas está implementado inline por enquanto
waltherCooldownTimer = 0;

// Vida / Tratamento de dano (sincronizado com variáveis globais)
// `global.player_hp` armazena a vida do jogador; função `TakeDamage` reduz essa vida
if (!variable_global_exists("player_hp")) global.player_hp = 100;
TakeDamage = function(_amount) {
    if (variable_global_exists("player_hp")) {
        global.player_hp = max(0, global.player_hp - _amount);
        show_debug_message("Jogador recebeu " + string(_amount) + " de dano. HP: " + string(global.player_hp));
        if (global.player_hp <= 0) {
            // Tratamento básico de morte: destruir a instância (pode ser expandido depois)
            
			//instance_destroy();
			
        }
    }
}



// --- Máquina de Estados ---
enum PLAYER_STATE {
    FREE,
    ATTACK
}
state = PLAYER_STATE.FREE;

// --- Methods ---

/// @function StateFree()
/// @descricao Estado padrão do jogador: processa entrada, movimento, animação, interação e combate.
StateFree = function() {
    ProcessInput();
    ProcessMovement();
    ProcessAnimation();
    ProcessInteraction();
    ProcessCombat(); // Keeps gun logic working for now
    
    // Verifica ataque corpo-a-corpo (Barra de espaço)
    if (keyboard_check_pressed(vk_space)) {
        state = PLAYER_STATE.ATTACK;
        image_index = 0;
        image_speed = 1;
        // Logic to stop movement is handled by not calling ProcessMovement
    }
}

/// @function StateAttack()
/// @descricao Estado de ataque corpo-a-corpo: cria um `oHitbox` no frame correto e aplica dano.
StateAttack = function() {
    // Stop movement
    hSpeed = 0;
    vSpeed = 0;
    
    // Create Hitbox on first frame (or specific frame)
    if (floor(image_index) == 1) { 
       if (!instance_exists(oHitbox)) { 
           // Calcula deslocamento do hitbox baseado na última direção de movimento.
           // Se não tivermos um vetor de facing específico, inferimos pelo `lastAxisMoved`.
           var _offX = 0;
           var _offY = 0;
           
           if (lastAxisMoved == "x") {
               _offX = facingDirection * 20;
           } else {
               // Determina cima/baixo baseado no sprite ou estado armazenado.
               // Como `lastYDir` não é armazenado, usamos o sprite atual como heurística.
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

    // Fim do ataque
    // Por enquanto usamos um temporizador como fallback caso não haja sprite de animação específico.
    
    // Checagem de animação (exemplo): quando a animação terminar, voltar ao estado FREE.
    
    // Como não temos sprite de ataque detalhado ainda, usamos `alarm[0]` como duração do ataque.
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
/// @descricao Lê entrada do teclado (WASD / setas) e atualiza `inputDirection`.
ProcessInput = function() {
    // Verificação de segurança para variáveis globais
    if (!variable_global_exists("dialogo")) global.dialogo = false;

    // Retorna cedo se um diálogo estiver aberto (desativa movimento)
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
/// @descricao Aplica movimentação com verificação de colisões em X e Y, e reduz velocidade por peso do inventário.
ProcessMovement = function() {
    // 1. Calcula velocidade baseada no peso (inventário)
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

   // =========================
	// COLISÃO HORIZONTAL
	// =========================

	if (
	    place_meeting(x + hSpeed, y, Obj_colisor)
	    || place_meeting(x + hSpeed, y, Obj_par_inimigos)
	)
	{
	    while (
	        !place_meeting(x + sign(hSpeed), y, Obj_colisor)
	        && !place_meeting(x + sign(hSpeed), y, Obj_par_inimigos)
	    )
	    {
	        x += sign(hSpeed);
	    }

	    hSpeed = 0;
	}

	x += hSpeed;

	// =========================
	// COLISÃO VERTICAL
	// =========================

	if (
	    place_meeting(x, y + vSpeed, Obj_colisor)
	    || place_meeting(x, y + vSpeed, Obj_par_inimigos)
	)
	{
	    while (
	        !place_meeting(x, y + sign(vSpeed), Obj_colisor)
	        && !place_meeting(x, y + sign(vSpeed), Obj_par_inimigos)
	    )
	    {
	        y += sign(vSpeed);
	    }

	    vSpeed = 0;
	}

	y += vSpeed;
}

/// @function ProcessAnimation()
/// @descricao Atualiza sprite e escala horizontal (`image_xscale`) com base na direção de movimento.
ProcessAnimation = function() {
    // Atualiza direção de facing com base no input horizontal
    if (inputDirection[0] != 0) {
        facingDirection = -inputDirection[0]; 
        lastAxisMoved = "x";
    } else if (inputDirection[1] != 0) {
        lastAxisMoved = "y";
    }

    // Troca sprites conforme movimento/parado e eixo principal do movimento
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
        if (!variable_global_exists("walther_reloading")) global.walther_reloading = 0;

        // Cooldowns
        if (global.walther_cooldown > 0) global.walther_cooldown--;
        
        if (global.walther_reloading > 0) {
            global.walther_reloading--;
            return; // Can't shoot or do anything weapon-related while reloading
        }

        // Shooting
        if (mouse_check_button_pressed(mb_left) && global.walther_cooldown <= 0) {
            if (global.walther_ammo > 0) {
                var _dir = point_direction(x, y, mouse_x, mouse_y);
                var _bullet = instance_create_layer(x, y - 8, "Instances", Obj_bala_walther_p38); // Assuming layer

                with (_bullet) {
                    direction = _dir;
                    sprite_index = Spr_bala_walther_p38;
                    image_angle = _dir;
                    // Ensure sprite not mirrored from parent
                    image_xscale = 1;
                    image_yscale = 1;
                    // Set damage from equipped weapon if available
                    if (variable_global_exists("arma_equipada") && variable_struct_exists(global.arma_equipada, "damage")) {
                        damage = global.arma_equipada.damage;
                    } else {
                        damage = 12;
                    }
                    speed = 12;
                    life = 60;
                }
                
                global.walther_ammo--;
                global.walther_cooldown = 12;
            } else {
                // Auto-Reload (Eject cartridges)
                AttemptReload();
            }
        }

        // Manual Reload
        if (keyboard_check_pressed(ord("R"))) {
             AttemptReload();
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

/// @function AttemptReload()
AttemptReload = function() {
    if (global.walther_ammo >= global.walther_max_ammo) return; // Cartucho já cheio

    var _invManager = instance_find(oInventoryManager, 0);
    if (_invManager != noone) {
        var _ammo_slot = -1;
        // Búsca a munição no inventário
        for (var i = 0; i < _invManager.maxSlots; i++) {
            var _item = _invManager.inventorySlots[i];
            if (_item != undefined && _item.id == "pistol_ammo") {
                _ammo_slot = i;
                break;
            }
        }
        
        // Achou recurso, carrega e destrói do inventário
        if (_ammo_slot != -1) {
            _invManager.InventoryRemove(_ammo_slot);
            global.walther_ammo = global.walther_max_ammo;
            global.walther_reloading = 60; // 1 second reload
            RepeatReloadAction();
            show_debug_message("Recarregando Walther...");
        } else {
            // Trigger UI warning
            global.msg_text = "SEM MUNIÇÃO!";
            global.msg_timer = 120; // 2 seconds
            show_debug_message("Sem munição de pistola no inventário!");
        }
    }
}
