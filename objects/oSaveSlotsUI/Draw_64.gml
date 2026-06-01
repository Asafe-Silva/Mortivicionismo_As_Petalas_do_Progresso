live_auto_call

draw_set_color(c_black);
draw_rectangle(0, 0, RES_W, RES_H, false);

draw_set_font(Fnt_dialogo);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// Header
draw_text_transformed(30, 20, "CONTINUAR", 2, 2, 0);
draw_text_transformed(30, 70, "Use [ESQ]/[DIR] para mover, [CIMA]/[BAIXO] nas opcoes. [ENTER] confirma", 0.7, 0.7, 0);

// Slots Layout
var _slot_w = 230;
var _slot_h = 350;
var _spacing = 50;
var _start_x = (RES_W - ((_slot_w * 3) + (_spacing * 2))) / 2;
var _start_y = 120;

for (var i = 0; i < 3; i++) {
    var _sx = _start_x + (i * (_slot_w + _spacing));
    var _sy = _start_y;
    
    // Draw Base Card
    if (i == selected_slot) {
        draw_set_color(c_dkgray);
        draw_set_alpha(0.8);
        draw_rectangle(_sx - 5, _sy - 5, _sx + _slot_w + 5, _sy + _slot_h + 5, false);
        draw_set_alpha(1);
        draw_set_color(c_yellow);
        draw_rectangle(_sx - 5, _sy - 5, _sx + _slot_w + 5, _sy + _slot_h + 5, true);
    } else {
        draw_set_color(c_dkgray);
        draw_set_alpha(0.5);
        draw_rectangle(_sx, _sy, _sx + _slot_w, _sy + _slot_h, false);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(_sx, _sy, _sx + _slot_w, _sy + _slot_h, true);
    }
    
    draw_set_color(c_white);
    
    if (slot_data[i] == undefined) {
        // Empty Slot
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_sx + _slot_w/2, _sy + _slot_h/2, "SLOT VAZIO\n[ENTER PARA NOVO]", 0.65, 0.65, 0);
    } else {
        // Has Data
        var _sData = slot_data[i];
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // Save Name
        var _name = variable_struct_exists(_sData, "save_name") ? _sData.save_name : ("Save " + string(i+1));
        draw_set_color(c_yellow);
        draw_text_ext_transformed(_sx + 15, _sy + 10, _name, 25, _slot_w - 30, 0.9, 0.9, 0);
        
        // Placeholder Image (just a box)
        draw_set_color(c_gray);
        draw_rectangle(_sx + 15, _sy + 50, _sx + _slot_w - 15, _sy + 150, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_sx + _slot_w/2, _sy + 100, "IMAGEM\nDO JOGO", 0.7, 0.7, 0);
        
        // Room info (optional juice)
        draw_set_color(c_silver);
        var _rname = variable_struct_exists(_sData, "room_name") ? _sData.room_name : "";
        draw_text_transformed(_sx + _slot_w/2, _sy + 170, string_replace(_rname, "Roo_", "Sala: "), 0.6, 0.6, 0);
        
        // Options: RENOMEAR, ENTRAR, APAGAR
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _opts = ["RENOMEAR", "ENTRAR", "APAGAR"];
        var _opt_y = _sy + 200;
        
        for (var o = 0; o < array_length(_opts); o++) {
            if (i == selected_slot && o == selected_action) {
                draw_set_color(c_yellow);
                draw_text(_sx + 15, _opt_y + (o * 40), "> " + _opts[o]);
            } else {
                draw_set_color(c_white);
                draw_text(_sx + 30, _opt_y + (o * 40), _opts[o]);
            }
        }
    }
}

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
