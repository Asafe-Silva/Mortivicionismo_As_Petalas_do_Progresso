#region Diálogo
// Garante que a variável global exista
if (!variable_global_exists("dialogo")) {
    global.dialogo = false;
}

if (global.dialogo) {
    hsp = 0;
    vsp = 0;
    movimento = 0;
    exit;
}

// só libera quando soltar o E
if (!keyboard_check(ord("E"))) {
    global.dialogo_lock = false;
}

// Se estiver próximo de um NPC e o diálogo estiver livre
if (!global.dialogo && !global.dialogo_lock) {
    if (distance_to_object(Obj_par_npcs) <= 10) {
        if (keyboard_check_pressed(ord("E"))) {

            var npc = instance_nearest(x, y, Obj_par_npcs);
            if (instance_exists(npc)) {
                var d = instance_create_layer(x, y, "dialogo", Obj_dialogo);
                d.npc_nome = npc.nome;

                global.dialogo = true;
                global.dialogo_lock = true; // 🔒 trava
            }
        }
    }
}

#endregion

// Reset flag de movimento
movimento = 0;

// Calcula o movimento como você já fazia (resultado -1/0/1)
move_x = -(keyboard_check(vk_left) || keyboard_check(ord("A"))) + (keyboard_check(vk_right) || keyboard_check(ord("D")));
move_y = -(keyboard_check(vk_up)   || keyboard_check(ord("W"))) + (keyboard_check(vk_down)  || keyboard_check(ord("S")));

hsp = move_x * spd;
vsp = move_y * spd;



		// --- Posicionamento suave da câmera ---
		var cam_x = x - (cam_width / 2); // x centralizado no player
		var cam_y = y - (cam_height / 2); // y centralizado no player

		// Interpolação suave
		var smooth = 0.1; // ajuste a suavidade
		var new_x = lerp(camera_get_view_x(cam), cam_x, smooth);
		var new_y = lerp(camera_get_view_y(cam), cam_y, smooth);

		// Atualiza posição da câmera
		camera_set_view_pos(cam, new_x, new_y);

		// --- Zoom suave ---
		cam_zoom = lerp(cam_zoom, cam_target_zoom, cam_speed);

		// Aplica zoom ajustando a largura e altura da view
		var new_w = cam_width / cam_zoom;
		var new_h = cam_height / cam_zoom;
		camera_set_view_size(cam, new_w, new_h);



// Atualiza "olhar" APENAS se houver movimento horizontal
if (move_x != 0) {
    // mapeamento: move_x == -1 (esquerda) -> olhar = 1 ; move_x == 1 (direita) -> olhar = -1
    olhar = -move_x;
    last_axis = "x";
} 
// Se não teve movimento horizontal, mas teve vertical, atualiza last_axis (memória do eixo)
else if (move_y != 0) {
    last_axis = "y";
}

// ====== Colisão horizontal (com proteção) ======
if (hsp != 0) {
    if (place_meeting(x + hsp, y, Obj_colisor)) {
        // Move "pixel a pixel" até encostar (cuidado com loops infinitos -> limite)
        var safety = 0;
        while (!place_meeting(x + sign(hsp), y, Obj_colisor) && safety < 100) {
            x += sign(hsp);
            safety += 1;
        }
        hsp = 0;
    }
}
x += hsp;

// ====== Colisão vertical (com proteção) ======
if (vsp != 0) {
    if (place_meeting(x, y + vsp,Obj_colisor)) {
        var safety2 = 0;
        while (!place_meeting(x, y + sign(vsp), Obj_colisor) && safety2 < 100) {
            y += sign(vsp);
            safety2 += 1;
        }
        vsp = 0;
    }
}
y += vsp;

// Atualiza flag de movimento
if (move_x != 0 || move_y != 0) movimento = 1;



if (movimento == 0) {
    sprite_index = Spr_prota_parado_militar;
    image_speed  = 0;
    image_xscale = olhar;
} else {
    if (last_axis == "x") {
        sprite_index = Spr_prota_corendo_militar;
        image_speed  = 1;
        image_xscale = olhar;
    } else if (last_axis == "y") {
        if (move_y < 0) {
            sprite_index = Spr_prota_cima_militar;
            image_speed  = 1; // anima normal
        } else if (move_y > 0) {
            sprite_index = Spr_prota_baixo_militar;
            image_speed  = 1; // anima normal
			
        } else {
            sprite_index = Spr_prota_parado_militar;
            image_speed  = 0;
            image_index  = 0;
            image_xscale = olhar;
        }
    }
}


