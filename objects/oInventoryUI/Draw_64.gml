live_auto_call

// --- Check if Menu is Active ---
var _inv_manager = instance_find(oInventoryManager, 0);
if (_inv_manager == noone || !_inv_manager.menuActive) exit;

// --- Draw Background ---
draw_set_alpha(0.50);
draw_set_colour(c_dark_overlay);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.00);

// --- Setup ---
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
hovered_slot = -1;

draw_set_font(Fnt_dialogo);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- 1. Menu Lateral (Left) ---
draw_set_alpha(0.8); // Darker background
draw_set_color(c_dark_overlay);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

var _mouse_click = device_mouse_check_button_pressed(0, mb_left);

for (var i = 0; i < array_length(menu_items); i++) {
    var _item_y = menu_y + (i * menu_spacing);
    
    // Check Click
    // Approximate bounding box for the text
    if (_mx > menu_x && _mx < menu_x + 100 && _my > _item_y && _my < _item_y + 20) {
        if (_mouse_click) {
            menu_selected_index = i;
            
            // Map index to MENU_TABS enum
            // "Resumo", "Sanidade", "Inventário", "Diálogos", "Moral", "Config", "Sair"
            switch (i) {
                case 0: _inv_manager.current_tab = MENU_TABS.RESUMO; break;
                case 1: _inv_manager.current_tab = MENU_TABS.SANIDADE; break;
                case 2: _inv_manager.current_tab = MENU_TABS.INVENTARIO; break;
                case 3: _inv_manager.current_tab = MENU_TABS.DIALOGOS; break;
                case 4: _inv_manager.current_tab = MENU_TABS.MORAL; break;
                case 5: _inv_manager.current_tab = MENU_TABS.CONFIG; break;
                case 6: // Sair (Close menu)
                    _inv_manager.menuActive = false;
                    global.game_paused = false;
                    break;
            }
        }
    }

    // Highlight visual selection syncing with tab (except "Sair")
    var _is_selected = false;
    if (_inv_manager.current_tab == i && i != 6) {
        _is_selected = true;
    }

    var _col = _is_selected ? c_text_highlight : c_text_normal;
    draw_set_color(_col);
    draw_text(menu_x, _item_y, menu_items[i]);
}

// --- TAB CONTENT (Boxes) ---
switch (_inv_manager.current_tab) {
    case MENU_TABS.RESUMO:
        // TODO: Resumo UI
        break;

    case MENU_TABS.SANIDADE:
        // --- 1. Top Section (Status) ---
        var _sanity = variable_global_exists("sanidade_atual") ? global.sanidade_atual : 100;
        var _status_text = "ESTADO ATUAL: ";
        
        if (_sanity >= 80) _status_text += "ESTÁVEL";
        else if (_sanity >= 50) _status_text += "ANSIOSA";
        else if (_sanity >= 20) _status_text += "PERTURBADA";
        else _status_text += "COLAPSO";
        
        draw_set_color(c_text_highlight);
        draw_text(grid_start_x, 20, _status_text);
        
        // Right align sanity value
        draw_set_halign(fa_right);
        draw_text(lore_rect[0] - 20, 20, string(_sanity) + "/100");
        draw_set_halign(fa_left); // reset
        
        // --- 2. Trauma Grids ---
        var _maiores = (_inv_manager != noone) ? _inv_manager.traumas_maiores : [];
        var _menores = (_inv_manager != noone) ? _inv_manager.traumas_menores : [];
        
        // Headers
        draw_set_color(c_text_normal);
        draw_set_halign(fa_center);
        var _w1 = trauma_grid_cols * (slot_size + slot_padding) - slot_padding;
        draw_text_transformed(trauma_grid_start_x + _w1/2, trauma_grid_start_y - 35, "TRAUMA MAIOR", 0.8, 0.8, 0);
        draw_text_transformed(trauma_grid_start_x + trauma_grid_spacing_x + _w1/2, trauma_grid_start_y - 35, "TRAUMA MENOR", 0.8, 0.8, 0);
        draw_set_halign(fa_left); // reset
        
        // Draw Both Grids Loop
        var _hover_trauma = undefined;
        
        for (var _g = 0; _g < 2; _g++) { // 0: Maior, 1: Menor
            var _arr_ref = (_g == 0) ? _maiores : _menores;
            var _grid_base_x = trauma_grid_start_x + (_g * trauma_grid_spacing_x);
            
            for (var r = 0; r < trauma_grid_rows; r++) {
                for (var c = 0; c < trauma_grid_cols; c++) {
                    var _idx = (r * trauma_grid_cols) + c;
                    var _sx = _grid_base_x + (c * (slot_size + slot_padding));
                    var _sy = trauma_grid_start_y + (r * (slot_size + slot_padding));
                    
                    // Box BG
                    draw_set_color(c_dark_overlay);
                    draw_set_alpha(0.8);
                    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                    draw_set_color(c_white);
                    draw_set_alpha(0.3);
                    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, true);
                    
                    // Hover
                    if (_mx >= _sx && _mx <= _sx + slot_size && _my >= _sy && _my <= _sy + slot_size) {
                        draw_set_alpha(0.2);
                        draw_set_color(c_white);
                        draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                        draw_set_alpha(1);
                        
                        // Set hovered trauma data if slot isn't empty
                        if (_idx < array_length(_arr_ref)) {
                            _hover_trauma = _arr_ref[_idx];
                        }
                    }
                    
                    // Draw Sprite if exists
                    if (_idx < array_length(_arr_ref)) {
                        var _t = _arr_ref[_idx];
                        if (sprite_exists(_t.sprite)) {
                            var _sc = min(slot_size / sprite_get_width(_t.sprite), slot_size / sprite_get_height(_t.sprite)) * 0.8;
                            draw_sprite_ext(_t.sprite, 0, _sx + slot_size/2, _sy + slot_size/2, _sc, _sc, 0, c_white, 1);
                        } else {
                            // Placeholder mark for text
                            draw_set_alpha(1);
                            draw_set_color(c_red);
                             draw_text(_sx + 5, _sy + 5, "X"); // debugging no-sprite items
                        }
                    }
                }
            }
        }
        
        // --- 3. Update Global Hover Item so lower panels draw correctly ---
        // I will reuse _hover_item from below, since Sanity tab only uses side panels for Traumas.
        // Easiest is to map _hover_trauma properties to be structurally compatible for drawing.
        if (_hover_trauma != undefined) {
             _hover_item = {
                 sprite: _hover_trauma.sprite,
                 name: _hover_trauma.name,
                 type: "Trauma (" + _hover_trauma.type + ")",
                 description: _hover_trauma.description
             };
        } else {
             _hover_item = undefined;
        }
        
        // --- 4. Draw Global Sanity Effects on Lore Panel ---
        // Even if hovering or not, on the Sanity tab the right panel should show global effects
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], true);
        
        var _lx = lore_rect[0] + 10;
        var _ly = lore_rect[1] + 10;
        var _lw = (lore_rect[2] - lore_rect[0]) - 20;
        
        draw_set_color(c_text_highlight);
        draw_text_ext_transformed(_lx, _ly, "*Estado atual afeta:", 35, _lw / 0.8, 0.8, 0.8, 0);
        _ly += 40; // Spacing for the header line before printing effects
        
        draw_set_color(c_white);
        var _fx_text = "";
        if (_sanity >= 80) _fx_text = "Nenhum efeito penalizante.";
        else if (_sanity >= 50) _fx_text = "-5% Concentração\n+10 de campo de visão";
        else if (_sanity >= 20) _fx_text = "-15% Concentração\nVisão em túnel";
        else _fx_text = "-50% Concentração\nRecebe 2x de dano!";
        
        draw_text_ext_transformed(_lx, _ly, _fx_text, 35, _lw / 0.8, 0.8, 0.8, 0);
        
        break;

    case MENU_TABS.INVENTARIO:
        // --- 2. Grid de Itens (Center Top) ---
        var _slots = (_inv_manager != noone) ? _inv_manager.inventorySlots : [];
        
        for (var r = 0; r < grid_rows; r++) {
            for (var c = 0; c < grid_cols; c++) {
                var _idx = (r * grid_cols) + c;
                var _sx = grid_start_x + (c * (slot_size + slot_padding));
                var _sy = grid_start_y + (r * (slot_size + slot_padding));
                
                // Draw Slot Background
                draw_set_color(c_dark_overlay);
                draw_set_alpha(0.8); // Darker
                draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                draw_set_color(c_white);
                draw_set_alpha(0.3);
                draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, true); // Subtle Border
        
                // Mouse Hover Logic
                if (_mx >= _sx && _mx <= _sx + slot_size && _my >= _sy && _my <= _sy + slot_size) {
                    hovered_slot = _idx;
                    draw_set_alpha(0.2);
                    draw_set_color(c_white);
                    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                    draw_set_alpha(1);
                }
        
                // Draw Item Sprite and Equipment Logic
                if (_idx < array_length(_slots)) {
                    var _item = _slots[_idx];
                    if (is_struct(_item) && variable_struct_exists(_item, "sprite")) {
                        var _spr = _item.sprite;
                        if (sprite_exists(_spr)) {
                            // Center sprite in slot
                            var _scale = min(slot_size / sprite_get_width(_spr), slot_size / sprite_get_height(_spr)) * 0.8;
                            draw_sprite_ext(_spr, 0, _sx + slot_size/2, _sy + slot_size/2, _scale, _scale, 0, c_white, 1);
                        }
                        
                        // --- Equipment Logic (Right Click) ---
                        if (hovered_slot == _idx) {
                            if (device_mouse_check_button_pressed(0, mb_right)) {
                                if (variable_struct_exists(_item, "type") && _item.type == "Weapon") {
                                    // Make sure global exists
                                    if (!variable_global_exists("arma_equipada")) global.arma_equipada = undefined;
                                    
                                    // Equip or Unequip
                                    if (global.arma_equipada == _item) {
                                        global.arma_equipada = undefined; // Unequip
                                    } else {
                                        global.arma_equipada = _item; // Equip
                                    }
                                }
                            }
                        }
                        
                        // --- Visual Feedback for Equipped Item ---
                        if (variable_global_exists("arma_equipada") && global.arma_equipada == _item) {
                            // Green Border
                            draw_set_color(c_lime);
                            draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, true);
                            
                            // "E" Indicator
                            draw_set_halign(fa_right);
                            draw_set_valign(fa_top);
                            if (variable_instance_exists(id, "Fnt_dialogo")) draw_set_font(Fnt_dialogo);
                            draw_text_transformed(_sx + slot_size - 4, _sy + 4, "E", 0.8, 0.8, 0);
                            
                            // Reset draw states
                            draw_set_color(c_white);
                            draw_set_halign(fa_left);
                        }
                    }
                }
            }
        }
        
        // --- Prepare Data for Panels ---
        var _hover_item = undefined;
        if (hovered_slot != -1 && _inv_manager != noone) {
            if (hovered_slot < array_length(_slots)) {
                _hover_item = _slots[hovered_slot];
            }
        }
        
        // --- 3. Painel de Visualização (Preview - Bottom Left) ---
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(preview_rect[0], preview_rect[1], preview_rect[2], preview_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(preview_rect[0], preview_rect[1], preview_rect[2], preview_rect[3], true); // White border
        
        if (is_struct(_hover_item)) {
            var _spr = _hover_item.sprite;
            if (sprite_exists(_spr)) {
                 var _box_w = preview_rect[2] - preview_rect[0];
                 var _box_h = preview_rect[3] - preview_rect[1];
                 var _scale = min(_box_w / sprite_get_width(_spr), _box_h / sprite_get_height(_spr)) * 0.8;
                 draw_sprite_ext(_spr, 0, preview_rect[0] + _box_w/2, preview_rect[1] + _box_h/2, _scale, _scale, 0, c_white, 1);
            }
        }
        
        // --- 4. Painel de Status (Bottom Center) ---
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(status_rect[0], status_rect[1], status_rect[2], status_rect[3], false);
        draw_set_alpha(1);
        // draw_set_color(c_white);
        // draw_rectangle(status_rect[0], status_rect[1], status_rect[2], status_rect[3], true); // Optional border for status
        
        if (is_struct(_hover_item)) {
            var _tx = status_rect[0] + 10;
            var _ty = status_rect[1] + 10;
            
            // Name
            draw_set_color(c_text_highlight);
            draw_text(_tx, _ty, _hover_item.name);
            _ty += 20;
            
            // Stats
            draw_set_color(c_text_normal);
            if (_hover_item.type == "Weapon") {
                var _dmg = variable_struct_exists(_hover_item, "damage") ? string(_hover_item.damage) : "?";
                var _cap = variable_struct_exists(_hover_item, "ammo_capacity") ? string(_hover_item.ammo_capacity) : "?";
                draw_text(_tx, _ty, "Dano: " + _dmg + " | Capacidade: " + _cap);
            } else if (_hover_item.type == "Consumable") {
                var _heal = variable_struct_exists(_hover_item, "heal_value") ? string(_hover_item.heal_value) : "?";
                draw_text(_tx, _ty, "Cura: " + _heal);
            } else {
                draw_text(_tx, _ty, "Tipo: " + _hover_item.type);
            }
        }
        
        // --- 5. Painel de Lore (Right) ---
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], true);
        
        if (is_struct(_hover_item)) {
            var _tx = lore_rect[0] + 10;
            var _ty = lore_rect[1] + 10;
            var _w = (lore_rect[2] - lore_rect[0]) - 20;
            
            draw_set_color(c_white);
            // Use draw_text_ext for text wrapping
            draw_text_ext(_tx, _ty, _hover_item.description, 35, _w);
        }
        break;

    case MENU_TABS.DIALOGOS:
        // TODO: Diálogos UI
        break;

    case MENU_TABS.MORAL:
        // --- 1. Top Section (Alignment Text) ---
        var _pol = variable_global_exists("moral_politica") ? global.moral_politica : 0;
        var _eti = variable_global_exists("moral_etica") ? global.moral_etica : 0;
        
        draw_set_color(c_text_normal);
        
        // Politica
        var _box_w = 480; // Widen box 
        var _box_h = 30;
        var _bx = grid_start_x;
        var _by = 15; // Raised slightly
        
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
         // Formatar: Militar [valor]/100/[valor] Revolucionario
        var _vPol1 = (_pol < 0) ? abs(_pol) : 0;
        var _vPol2 = (_pol > 0) ? _pol : 0;
        var _str_pol = "Militar " + string(_vPol1) + "/100/" + string(_vPol2) + " Revolucionário";
        
        // Draw centered relative to the box width
        draw_text(_bx + _box_w/2, _by + _box_h/2, _str_pol);
        
        // Etica
        _by += 40;
        draw_rectangle(_bx, _by, _bx + _box_w, _by + _box_h, true);
        
        // Formatar: Boa pessoa [valor]/100/[valor] Má pessoa
        var _vEti1 = (_eti > 0) ? _eti : 0; // Boa pessoa = positivo
        var _vEti2 = (_eti < 0) ? abs(_eti) : 0; // Ma pessoa = negativo
        var _str_eti = "Boa pessoa " + string(_vEti1) + "/100/" + string(_vEti2) + " Má pessoa";
        draw_text(_bx + _box_w/2, _by + _box_h/2, _str_eti);
        
        draw_set_halign(fa_left); // Reset
        draw_set_valign(fa_top);  // Reset
        
        // --- 2. Medals Grid (Center) ---
        var _medals = (_inv_manager != noone) ? _inv_manager.medals_slots : [];
        var _hover_medal = undefined;
        
        for (var r = 0; r < medal_grid_rows; r++) {
            for (var c = 0; c < medal_grid_cols; c++) {
                var _idx = (r * medal_grid_cols) + c;
                var _sx = medal_grid_start_x + (c * (slot_size + slot_padding));
                var _sy = medal_grid_start_y + (r * (slot_size + slot_padding));
                
                // Box BG
                draw_set_color(c_dark_overlay);
                draw_set_alpha(0.8);
                draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                draw_set_color(c_white);
                draw_set_alpha(0.3);
                draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, true); // Subtle Border
                
                // Hover Check
                if (_mx >= _sx && _mx <= _sx + slot_size && _my >= _sy && _my <= _sy + slot_size) {
                    draw_set_alpha(0.2);
                    draw_set_color(c_white);
                    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);
                    draw_set_alpha(1);
                    
                    if (_idx < array_length(_medals) && is_struct(_medals[_idx])) {
                        _hover_medal = _medals[_idx];
                    }
                }
                
                // Draw Medal Sprite
                if (_idx < array_length(_medals) && is_struct(_medals[_idx])) {
                    var _spr = _medals[_idx].sprite;
                    if (sprite_exists(_spr)) {
                        var _sc = min(slot_size / sprite_get_width(_spr), slot_size / sprite_get_height(_spr)) * 0.8;
                        draw_sprite_ext(_spr, 0, _sx + slot_size/2, _sy + slot_size/2, _sc, _sc, 0, c_white, 1);
                    } else {
                        // Placeholder
                        draw_set_alpha(1);
                        draw_set_color(c_yellow);
                        draw_text(_sx + 5, _sy + 5, "M"); // Placeholder mark
                    }
                }
            }
        }
        
        // --- 3. Panels (Bottom & Right) ---
        
        // --- 3. Panels (Bottom & Right) ---
        
        // Lore Panel (Right) - Static Explicative Text
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], true);
        
        var _lx = lore_rect[0] + 10;
        var _ly = lore_rect[1] + 10;
        var _lw = (lore_rect[2] - lore_rect[0]) - 20;
        draw_set_color(c_text_normal);
        draw_text_ext(_lx, _ly, "• CADA UM DOS 21 espaços de medalha é PARA VC VER AS SUAS HONRAS MILITARES", 25, _lw); // Increased line separation
        
        // Preview Panel (Bottom Left)
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(preview_rect[0], preview_rect[1], preview_rect[2], preview_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(preview_rect[0], preview_rect[1], preview_rect[2], preview_rect[3], true);
        
        if (is_struct(_hover_medal)) {
            var _spr = _hover_medal.sprite;
            if (sprite_exists(_spr)) {
                 var _box_w = preview_rect[2] - preview_rect[0];
                 var _box_h = preview_rect[3] - preview_rect[1];
                 var _scale = min(_box_w / sprite_get_width(_spr), _box_h / sprite_get_height(_spr)) * 0.8;
                 draw_sprite_ext(_spr, 0, preview_rect[0] + _box_w/2, preview_rect[1] + _box_h/2, _scale, _scale, 0, c_white, 1);
            } else {
                draw_set_color(c_gray);
                draw_text_ext(preview_rect[0] + 5, preview_rect[1] + 5, "Sem imagem da medalha.", 20, preview_rect[2] - preview_rect[0] - 10);
            }
        } else {
            draw_set_color(c_gray);
            draw_text_ext(preview_rect[0] + 5, preview_rect[1] + 5, "Sem imagem de MEDALHA, pois VC NÃO POSSUI", 20, preview_rect[2] - preview_rect[0] - 10);
        }
        
        // Status Panel (Bottom Center)
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(status_rect[0], status_rect[1], status_rect[2], status_rect[3], false);
        draw_set_alpha(1);
        
        var _tx = status_rect[0] + 10;
        var _ty = status_rect[1] + 10;
        var _tw = status_rect[2] - status_rect[0] - 20;
        
        if (is_struct(_hover_medal)) {
            draw_set_color(c_text_highlight);
            draw_text(_tx, _ty, _hover_medal.name);
            _ty += 20;
            draw_set_color(c_text_normal);
            draw_text_ext(_tx, _ty, _hover_medal.description, 20, _tw);
        } else {
            draw_set_color(c_gray);
            draw_text(_tx, _ty, "ESPAÇO SEM MEDALHA");
            _ty += 25;
            draw_text_ext(_tx, _ty, "É AQUI ONDE SUAS MEDALHAS DE GUERRA SÃO GUARDADAS.", 20, _tw);
        }
        break;

    case MENU_TABS.CONFIG:
        // --- 1. Main Area (Options List) ---
        var _opts_x = grid_start_x;
        var _opts_y = 60;  // Restore initial height
        var _spacing = 50; // Tighter vertical spacing
        var _txt_scale = 0.65; // Scale down the text
        
        draw_set_color(c_text_normal);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        var _hover_config = undefined; // To store hovered item name for Status Panel
        var _hb_w = 480;
        var _hb_h = 30;
        var _btn_w = 40; // Clickable area for arrows
        
        // Push the values way to the right so they dont overlap the labels
        var _ctrl_x = _opts_x + 280; 
        
        // --- 1. Idioma ---
        var _hy = _opts_y - _hb_h/2;
        if (_mx >= _opts_x && _mx <= _opts_x + _hb_w && _my >= _hy && _my <= _hy + _hb_h) {
             draw_set_alpha(0.2); draw_rectangle(_opts_x, _hy, _opts_x + _hb_w, _hy + _hb_h, false); draw_set_alpha(1);
             _hover_config = "idioma";
        }
        draw_text_transformed(_opts_x, _opts_y, "IDIOMA:", _txt_scale, _txt_scale, 0);
        
        var _left_arr_x = _ctrl_x;
        if (_mx >= _left_arr_x && _mx <= _left_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) config_idioma = (config_idioma == "Português") ? "English" : "Português";
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x, _opts_y, "<", _txt_scale, _txt_scale, 0);
        
        draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x + 25, _opts_y, config_idioma, _txt_scale, _txt_scale, 0);
        
        var _right_arr_x = _left_arr_x + 25 + (string_width(config_idioma) * _txt_scale) + 15;
        if (_mx >= _right_arr_x && _mx <= _right_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) config_idioma = (config_idioma == "Português") ? "English" : "Português";
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_right_arr_x, _opts_y, ">", _txt_scale, _txt_scale, 0);
        
        _opts_y += _spacing;
        
        // --- 2. Vol Geral ---
        _hy = _opts_y - _hb_h/2;
        if (_mx >= _opts_x && _mx <= _opts_x + _hb_w && _my >= _hy && _my <= _hy + _hb_h) {
             draw_set_alpha(0.2); draw_rectangle(_opts_x, _hy, _opts_x + _hb_w, _hy + _hb_h, false); draw_set_alpha(1);
             _hover_config = "vol_geral";
        }
        draw_set_color(c_text_normal);
        draw_text_transformed(_opts_x, _opts_y, "Volume Geral:", _txt_scale, _txt_scale, 0);
        
        _left_arr_x = _ctrl_x;
        if (_mx >= _left_arr_x && _mx <= _left_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_geral = max(0, vol_geral - 10);
                audio_master_gain(vol_geral / 100);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x, _opts_y, "<", _txt_scale, _txt_scale, 0);
        
        draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x + 25, _opts_y, string(vol_geral), _txt_scale, _txt_scale, 0);
        
        _right_arr_x = _left_arr_x + 25 + (string_width(string(vol_geral)) * _txt_scale) + 15;
        if (_mx >= _right_arr_x && _mx <= _right_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_geral = min(100, vol_geral + 10);
                audio_master_gain(vol_geral / 100);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_right_arr_x, _opts_y, ">", _txt_scale, _txt_scale, 0);
        
        _opts_y += _spacing;
        
        // --- 3. Vol Fundo ---
        _hy = _opts_y - _hb_h/2;
        if (_mx >= _opts_x && _mx <= _opts_x + _hb_w && _my >= _hy && _my <= _hy + _hb_h) {
             draw_set_alpha(0.2); draw_rectangle(_opts_x, _hy, _opts_x + _hb_w, _hy + _hb_h, false); draw_set_alpha(1);
             _hover_config = "vol_fundo";
        }
        draw_set_color(c_text_normal);
        draw_text_transformed(_opts_x, _opts_y, "Volume do Fundo:", _txt_scale, _txt_scale, 0);
        
        _left_arr_x = _ctrl_x;
        if (_mx >= _left_arr_x && _mx <= _left_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_fundo = max(0, vol_fundo - 10);
                if (audio_group_is_loaded(audiogroup_sfx)) audio_group_set_gain(audiogroup_sfx, vol_fundo / 100, 0);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x, _opts_y, "<", _txt_scale, _txt_scale, 0);
        
        draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x + 25, _opts_y, string(vol_fundo), _txt_scale, _txt_scale, 0);
        
        _right_arr_x = _left_arr_x + 25 + (string_width(string(vol_fundo)) * _txt_scale) + 15;
        if (_mx >= _right_arr_x && _mx <= _right_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_fundo = min(100, vol_fundo + 10);
                if (audio_group_is_loaded(audiogroup_sfx)) audio_group_set_gain(audiogroup_sfx, vol_fundo / 100, 0);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_right_arr_x, _opts_y, ">", _txt_scale, _txt_scale, 0);
        
        _opts_y += _spacing;
        
        // --- 4. Vol Musica ---
        _hy = _opts_y - _hb_h/2;
        if (_mx >= _opts_x && _mx <= _opts_x + _hb_w && _my >= _hy && _my <= _hy + _hb_h) {
             draw_set_alpha(0.2); draw_rectangle(_opts_x, _hy, _opts_x + _hb_w, _hy + _hb_h, false); draw_set_alpha(1);
             _hover_config = "vol_musica";
        }
        draw_set_color(c_text_normal);
        draw_text_transformed(_opts_x, _opts_y, "Volume da Música:", _txt_scale, _txt_scale, 0);
        
        _left_arr_x = _ctrl_x;
        if (_mx >= _left_arr_x && _mx <= _left_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_musica = max(0, vol_musica - 10);
                if (audio_group_is_loaded(audiogroup_bgm)) audio_group_set_gain(audiogroup_bgm, vol_musica / 100, 0);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x, _opts_y, "<", _txt_scale, _txt_scale, 0);
        
        draw_set_color(c_text_normal);
        draw_text_transformed(_left_arr_x + 25, _opts_y, string(vol_musica), _txt_scale, _txt_scale, 0);
        
        _right_arr_x = _left_arr_x + 25 + (string_width(string(vol_musica)) * _txt_scale) + 15;
        if (_mx >= _right_arr_x && _mx <= _right_arr_x + _btn_w && _my >= _hy && _my <= _hy + _hb_h) {
            draw_set_color(c_text_highlight);
            if (_mouse_click) {
                vol_musica = min(100, vol_musica + 10);
                if (audio_group_is_loaded(audiogroup_bgm)) audio_group_set_gain(audiogroup_bgm, vol_musica / 100, 0);
            }
        } else draw_set_color(c_text_normal);
        draw_text_transformed(_right_arr_x, _opts_y, ">", _txt_scale, _txt_scale, 0);
        
        // Reset alignment
        draw_set_valign(fa_top);
        
        // --- 5. Action Buttons (Bottom Main Area) ---
        var _btn_w2 = 140; // Even smaller, no wrapping needed if we drop text size
        var _btn_h2 = 35;
        var _bx1 = grid_start_x;
        var _by1 = status_rect[1] - _btn_h2 - 20; // Re-established spacing to status rect
        
        var _btns = ["SALVA ALTERAÇÕES", "Salvar Jogo", "Tela de Título"];
        
        for (var b = 0; b < array_length(_btns); b++) {
            var _cur_bx = _bx1 + (b * (_btn_w2 + 15)); // spacing of 15
            
            // Hover
            var _hovered_btn = (_mx >= _cur_bx && _mx <= _cur_bx + _btn_w2 && _my >= _by1 && _my <= _by1 + _btn_h2);
            var _bcol = _hovered_btn ? c_text_highlight : c_white;
            
            if (_hovered_btn) {
                draw_set_alpha(0.2);
                draw_set_color(c_white);
                draw_rectangle(_cur_bx, _by1, _cur_bx + _btn_w2, _by1 + _btn_h2, false);
                draw_set_alpha(1);
            }
            
            draw_set_color(_bcol);
            draw_rectangle(_cur_bx, _by1, _cur_bx + _btn_w2, _by1 + _btn_h2, true);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            // Multi-line text using ext_transformed to fit inside the button
            draw_text_ext_transformed(_cur_bx + _btn_w2/2, _by1 + _btn_h2/2, _btns[b], 20, _btn_w2 / 0.65, 0.65, 0.65, 0);
            
            if (_hovered_btn && _mouse_click) {
                if (b == 0) {
                    show_debug_message("Settings saved (placeholder)");
                } else if (b == 1) { // Salvar Jogo
                    if (variable_global_exists("current_save_slot") && variable_global_exists("current_save_name")) {
                        SaveGame(global.current_save_slot, global.current_save_name);
                    } else {
                        // Fallback if not started via save menu
                        SaveGame(1, "Save");
                    }
                } else if (b == 2) { // Tela de Título
                    if (_inv_manager != noone) {
                        _inv_manager.menuActive = false;
                    }
                    global.game_paused = false;
                    var _t = instance_create_depth(0, 0, -9999, oTransition);
                    _t.target_room = rm_TitleScreen;
                }
            }
        }
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // --- 6. Panels (Bottom & Right) ---
        
        // Lore Panel (Right)
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(lore_rect[0], lore_rect[1], lore_rect[2], lore_rect[3], true);
        
        var _lx = lore_rect[0] + 10;
        var _ly = lore_rect[1] + 10;
        var _lw = (lore_rect[2] - lore_rect[0]) - 20;
        
        var _lore_text = "Bem vindo Ao BRASIL! ou Para:\n\nPortugal\nAngola\nMoçambique\nGuiné-Bissau\nCabo Verde\nGuiné Equatorial\nSão Tomé e Príncipe\n\nou a\n\nTimor-Leste";
        // Shrink the font size for lore using transformed to avoid bounds spilling 
        draw_text_ext_transformed(_lx, _ly, _lore_text, 25, _lw / 0.8, 0.8, 0.8, 0);
        
        // Status Panel (Bottom Center)
        draw_set_color(c_dark_overlay);
        draw_set_alpha(0.8);
        draw_rectangle(status_rect[0], status_rect[1], status_rect[2], status_rect[3], false);
        draw_set_alpha(1);
        
        var _tx = status_rect[0] + 10;
        var _ty = status_rect[1] + 10;
        var _tw = status_rect[2] - status_rect[0] - 20;
        
        draw_set_color(c_text_highlight);
        
        if (_hover_config == "idioma") {
             draw_text(_tx, _ty, "IDIOMA");
             draw_set_color(c_text_normal);
             draw_text_ext(_tx, _ty + 30, "Você escolheu " + config_idioma + ".", 25, _tw);
        } else if (_hover_config == "vol_geral") {
             draw_text(_tx, _ty, "VOLUME DO JOGO (GERAL)");
             draw_set_color(c_text_normal);
             draw_text_ext(_tx, _ty + 30, "Altera o volume de todos os sons do jogo globalmente.", 25, _tw);
        } else if (_hover_config == "vol_fundo") {
             draw_text(_tx, _ty, "VOLUME DO FUNDO");
             draw_set_color(c_text_normal);
             draw_text_ext(_tx, _ty + 30, "Altera o volume dos efeitos sonoros de ambiente e background.", 25, _tw);
        } else if (_hover_config == "vol_musica") {
             draw_text(_tx, _ty, "VOLUME DA MÚSICA");
             draw_set_color(c_text_normal);
             draw_text_ext(_tx, _ty + 30, "Altera o volume das trilhas sonoras do jogo.", 25, _tw);
        } else {
             draw_text(_tx, _ty, "CONFIGURAÇÕES DO JOGO");
             draw_set_color(c_gray);
             draw_text_ext(_tx, _ty + 30, "Passe o mouse sobre as opções para ver informações.", 25, _tw);
        }
        break;
}
