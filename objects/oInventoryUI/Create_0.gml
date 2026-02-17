
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
grid_rows = 4;
slot_size = 100;
slot_padding = 10;
grid_start_x = menu_width + 100; // Offset from menu
grid_start_y = 150;

// Preview Panel (Bottom Left)
preview_rect = [50, 600, 50 + 300, 600 + 300]; // x1, y1, x2, y2

// Status Panel (Bottom Center)
status_rect = [grid_start_x, 600, grid_start_x + (slot_size + slot_padding) * grid_cols, 600 + 150];

// Lore Panel (Right Column)
lore_rect = [gui_width * 0.80, 100, gui_width - 50, gui_height - 100];

// State
hovered_slot = -1;
display_set_gui_size(gui_width, gui_height);
