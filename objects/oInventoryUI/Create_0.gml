
// Layout Constants (Based on 1920x1080)
gui_width = 1920;
gui_height = 1080;

// Colors
c_dark_overlay = c_black;
c_text_highlight = c_yellow;
c_text_normal = c_white;

// Menu (Left Panel)
menu_items = ["Resumo", "Sanidade", "Inventário", "Diálogos", "Moral", "Config", "Sair"];
menu_selected_index = 2; // "Inventário" selected by default for now
menu_x = 50;
menu_y = 100;
menu_spacing = 60;
menu_width = gui_width * 0.20;

// Inventory Grid (Center Top)
grid_cols = 6;
grid_rows = 5;
slot_size = 90; // Reduced slighty to fit vertically
slot_padding = 8;
grid_start_x = menu_width + 40; // Offset from menu
grid_start_y = 50; // Higher up

// Preview Panel (Bottom Left - Relative to Menu/Grid)
// Let's place it below the menu, or keep it bottom left of the overlay area.
var _preview_side = 250;
preview_rect = [50, gui_height - _preview_side - 50, 50 + _preview_side, gui_height - 50];

// Status Panel (Bottom Center - Below Grid)
// Extends from left of grid to right of grid
var _grid_width = (slot_size + slot_padding) * grid_cols;
status_rect = [grid_start_x, grid_start_y + (slot_size + slot_padding) * grid_rows + 20, grid_start_x + _grid_width, gui_height - 50];

// Lore Panel (Right Column - Full Height)
// From end of grid + padding to right edge
var _lore_start_x = grid_start_x + _grid_width + 40;
lore_rect = [_lore_start_x, 50, gui_width - 50, gui_height - 50];

// State
hovered_slot = -1;
display_set_gui_size(gui_width, gui_height);
