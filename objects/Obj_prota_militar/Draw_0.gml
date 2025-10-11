draw_self();  // Desenha o sprite normal do objeto

// Reset de shader e alpha
draw_set_color(c_white);


// --- DEBUG VISUAL: ativado com TAB ---
if (keyboard_check(vk_tab)) {

    var sx = 100;    // x inicial para desenhar miniaturas
    var sy = 40;     // y inicial
    var pad = 40;    // espaçamento entre frames

    // Função para desenhar frames de um sprite
    function dbg_draw_frames(spr, label, ox, oy, pad) {
	    if (sprite_exists(spr)) {
	        var n = sprite_get_number(spr);
	        draw_text(ox, oy - 16, label + " frames: " + string(n));
	        for (var i = 0; i < n; i++) {
	            draw_sprite(spr, i, ox + i * pad, oy);  // agora pad existe aqui
	            draw_text(ox + i * pad, oy + 18, string(i));
	        }
	    } else {
	        draw_text(ox, oy, label + " NÃO EXISTE");
	    }
	}


    // Desenha os sprites que você quer debugar
	dbg_draw_frames(Spr_prota_cima_militar, "CIMA", sx, sy, pad);
	dbg_draw_frames(Spr_prota_baixo_militar, "BAIXO", sx, sy + 80, pad);
	dbg_draw_frames(Spr_prota_corendo_militar, "CORRENDO", sx, sy + 160, pad);
	dbg_draw_frames(Spr_prota_parado_militar, "PARADO", sx, sy + 240, pad);


    // Informações técnicas adicionais
    var infoY = sy + 320;
    draw_text(sx, infoY, "SprCima w,h: " + string(sprite_get_width(Spr_prota_cima_militar)) + "," + string(sprite_get_height(Spr_prota_cima_militar)));
    draw_text(sx, infoY + 16, "SprBaixo w,h: " + string(sprite_get_width(Spr_prota_baixo_militar)) + "," + string(sprite_get_height(Spr_prota_baixo_militar)));
    draw_text(sx, infoY + 32, "SprCorrendo w,h: " + string(sprite_get_width(Spr_prota_corendo_militar)) + "," + string(sprite_get_height(Spr_prota_corendo_militar)));
    draw_text(sx, infoY + 48, "SprParado w,h: " + string(sprite_get_width(Spr_prota_parado_militar)) + "," + string(sprite_get_height(Spr_prota_parado_militar)));
}
	