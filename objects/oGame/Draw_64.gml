/// @description Draw HUD (Sanity, etc)
live_auto_call

// Sanity Bar - Top Left
var _barX = 20;
var _barY = 20;
var _barW = 200;
var _barH = 20;

// Draw Background
draw_set_color(c_dkgray);
draw_rectangle(_barX, _barY, _barX + _barW, _barY + _barH, false);

// Draw Fill
if (variable_global_exists("sanidade_atual") && variable_global_exists("sanidade_max")) {
    var _pct = global.sanidade_atual / global.sanidade_max;
    // Purple color for sanity
    draw_set_color(make_color_rgb(128, 0, 128)); 
    draw_rectangle(_barX, _barY, _barX + (_barW * _pct), _barY + _barH, false);
    
    // Draw Border
    draw_set_color(c_white);
    draw_rectangle(_barX, _barY, _barX + _barW, _barY + _barH, true);
    
    // Draw Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    // Use a font if available, or default
    if (variable_instance_exists(id, "Fnt_dialogo")) draw_set_font(Fnt_dialogo);
    
    draw_text(_barX + _barW/2, _barY + _barH/2, string(round(global.sanidade_atual)) + " / " + string(global.sanidade_max));
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
