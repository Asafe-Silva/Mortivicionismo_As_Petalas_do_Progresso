live_auto_call

// --- Check if Menu is Active ---
var _inv_manager = instance_find(oInventoryManager, 0);
if (_inv_manager == noone || !_inv_manager.menuActive) exit;

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
draw_rectangle(0, 0, menu_width, gui_height, false);
draw_set_alpha(1);

for (var i = 0; i < array_length(menu_items); i++) {
    var _col = (i == menu_selected_index) ? c_text_highlight : c_text_normal;
    draw_set_color(_col);
    draw_text(menu_x, menu_y + (i * menu_spacing), menu_items[i]);
}

// --- 2. Grid de Itens (Center Top) ---
// _inv_manager is already found above
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

        // Draw Item Sprite
        if (_idx < array_length(_slots)) {
            var _item = _slots[_idx];
            if (is_struct(_item) && variable_struct_exists(_item, "sprite")) {
                var _spr = _item.sprite;
                if (sprite_exists(_spr)) {
                    // Center sprite in slot
                    var _scale = min(slot_size / sprite_get_width(_spr), slot_size / sprite_get_height(_spr)) * 0.8;
                    draw_sprite_ext(_spr, 0, _sx + slot_size/2, _sy + slot_size/2, _scale, _scale, 0, c_white, 1);
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
