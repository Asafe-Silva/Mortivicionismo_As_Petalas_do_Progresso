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
grid_cols = 9;
grid_rows = 7;
slot_size = 40; 
slot_padding = 6; 
grid_start_x = menu_width + 10; // Slightly closer to menu
grid_start_y = 20; // Higher up

// Trauma Grids (Sanity Tab)
trauma_grid_cols = 4;
trauma_grid_rows = 5;
trauma_grid_start_x = menu_width + 10;
trauma_grid_start_y = 100; // Lower to leave room for text
trauma_grid_spacing_x = 220; // Space between Major and Minor grids

// Medal Grid (Moral Tab)
medal_grid_cols = 7;
medal_grid_rows = 3;
medal_grid_start_x = grid_start_x;
medal_grid_start_y = 110; // Lower to leave room for the Alignment bounds text

// Config Tab Variables
config_idioma = "Português";
vol_geral = 100;
vol_fundo = 100;
vol_musica = 100;

// Preview Panel (Bottom Left)
var _preview_side = 120;
preview_rect = [25, gui_height - _preview_side - 25, 25 + _preview_side, gui_height - 25];

// Lore Panel (Right Column - Fixed Width)
var _lore_width = 220;
lore_rect = [gui_width - _lore_width - 25, 25, gui_width - 25, gui_height - 25];

// Status Panel (Bottom Center - Wide and Short)
// Spans from Grid Start to Lore Start
var _status_height = 120;
status_rect = [grid_start_x, gui_height - _status_height - 25, lore_rect[0] - 20, gui_height - 25];

// State
hovered_slot = -1;
display_set_gui_size(gui_width, gui_height);

