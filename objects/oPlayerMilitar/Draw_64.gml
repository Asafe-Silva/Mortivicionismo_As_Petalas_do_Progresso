/// @description 
// Simple debug toggle - kept for legacy support if needed, but cleaned up
// Debug Info
if (keyboard_check(vk_tab)) {
    draw_set_color(c_white);
    draw_text(12, 100 - 64, "State: " + (isMoving ? "Moving" : "Idle"));
    draw_text(12, 100 - 48, "Facing: " + string(facingDirection));
    draw_text(12, 100 - 32, "Input: " + string(inputDirection));
}

// --- On-Screen Messages ---
if (variable_global_exists("msg_timer") && global.msg_timer > 0) {
    global.msg_timer--;
    
    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() / 4; // Terço superior da tela
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _fnt = asset_get_index("Fnt_dialogo");
    if (_fnt != -1) {
        draw_set_font(_fnt);
    }
    
    // Efeito de fade out
    var _alpha = 1;
    if (global.msg_timer < 30) {
        _alpha = global.msg_timer / 30; // Smooth fade nos ultimos 30 frames
    }
    
    draw_set_alpha(_alpha);
    var _scale = 1.5; // Texto um pouco maior para ficar visível
    
    // Drop Shadow (Sombra pra leitura fácil)
    draw_set_color(c_black);
    draw_text_transformed(_cx + 2, _cy + 2, global.msg_text, _scale, _scale, 0);
    
    // Texto Vermelho (Alerta)
    draw_set_color(c_red);
    draw_text_transformed(_cx, _cy, global.msg_text, _scale, _scale, 0);
    
    // Resetando valores para não quebrar outros Draws do game
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
	