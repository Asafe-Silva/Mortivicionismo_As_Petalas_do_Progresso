live_auto_call 

// Layout Constants (Scaled for 960x540)
// Using Macros RES_W and RES_H
gui_width = RES_W;
gui_height = RES_H;

// Colors
c_dark_overlay = c_black;
c_text_highlight = c_yellow;
c_text_normal = c_white;

// Menu (Left Panel)
menu_items = ["Resumo", "Sanidade", "Inventário", "Diálogos", "Moral", "Config", "Sair"];
menu_selected_index = 2; 
menu_x = 25; // Scaled down
menu_y = 50; // Scaled down
menu_spacing = 30; // Scaled down
menu_width = gui_width * 0.20;

// Inventory Grid (Center Top)
grid_cols = 6;
grid_rows = 5;
slot_size = 40; // Scaled down (was 90)
slot_padding = 6; // Scaled down
grid_start_x = menu_width + 20; 
grid_start_y = 30; 

// Preview Panel (Bottom Left - Relative to Menu/Grid)
var _preview_side = 120; // Scaled down (was 250)
preview_rect = [25, gui_height - _preview_side - 25, 25 + _preview_side, gui_height - 25];

// Status Panel (Bottom Center - Below Grid)
var _grid_width = (slot_size + slot_padding) * grid_cols;
status_rect = [grid_start_x, grid_start_y + (slot_size + slot_padding) * grid_rows + 10, grid_start_x + _grid_width, gui_height - 25];

// Lore Panel (Right Column - Full Height)
var _lore_start_x = grid_start_x + _grid_width + 20;
lore_rect = [_lore_start_x, 25, gui_width - 25, gui_height - 25];

// State
hovered_slot = -1;
display_set_gui_size(gui_width, gui_height);

