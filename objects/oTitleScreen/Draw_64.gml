live_auto_call

// Draw Background
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);

// Title Text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(Fnt_dialogo); 
draw_set_color(c_white);

var _start_x = 50;
var _title_y = 100;

// Main Title
draw_text_transformed(_start_x, _title_y, "MORTIVICIONISMO", 2, 2, 0);

// Subtitle
draw_set_color(c_ltgray);
draw_text_transformed(_start_x, _title_y + 60, "As pétalas do progresso", 1.2, 1.2, 0);

// Menu Options
var _menu_y = 250;
var _menu_spacing = 40;

for (var i = 0; i < array_length(menu_options); i++) {
    var _opt_y = _menu_y + (i * _menu_spacing);
    
    if (i == menu_selected) {
        draw_set_color(c_yellow);
        // Draw selection cursor (bullet point imitating the sketch)
        draw_text(_start_x - 15 + cursor_offset, _opt_y, ">");
    } else {
        draw_set_color(c_white);
    }
    
    draw_text(_start_x, _opt_y, "  " + menu_options[i]); // spaces to simulate the bullet indentation from sketch
}
