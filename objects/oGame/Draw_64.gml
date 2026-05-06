/// @description Draw HUD (HP, Sanity)
live_auto_call

// Hide HUD if inventory is open
if (instance_exists(oInventoryManager) && oInventoryManager.menuActive) {
    return;
}

// Ensure globals exist
if (!variable_global_exists("player_hp") || !variable_global_exists("sanidade_atual")) exit;

var _barX = 40;
var _barY = 40;
var _barW = 300;
var _barH = 25;
var _spacingY = 40; // Spacing between bars

// --- 1. Health Bar (HP) ---
var _hp_pct = max(0, hp_lerp / global.player_hp_max);

// Background (Dark Gray)
draw_set_color(c_dkgray);
draw_rectangle(_barX, _barY, _barX + _barW, _barY + _barH, false);

// Fill (Green or Red depending on health - let's use a nice Green fading to Red)
// Or just keep the instructions: Red or Green.
var _hp_color = (_hp_pct > 0.3) ? make_color_rgb(46, 204, 113) : make_color_rgb(231, 76, 60);
draw_set_color(_hp_color);
if (_hp_pct > 0) {
    draw_rectangle(_barX, _barY, _barX + (_barW * _hp_pct), _barY + _barH, false);
}

// Border
draw_set_color(c_white);
draw_rectangle(_barX, _barY, _barX + _barW, _barY + _barH, true);

// Text & Values
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
if (variable_instance_exists(id, "Fnt_dialogo")) draw_set_font(Fnt_dialogo);
draw_text(_barX + _barW/2, _barY + _barH/2, string(round(global.player_hp)) + " / " + string(global.player_hp_max));

// Label "HP"
draw_set_halign(fa_right);
draw_text(_barX - 10, _barY + _barH/2, "HP");

// --- 2. Sanity Bar (SAN) ---
var _sanY = _barY + _spacingY;
var _san_max = variable_global_exists("sanidade_max") ? global.sanidade_max : 100;
var _san_pct = max(0, sanity_lerp / _san_max);

// Background
draw_set_color(c_dkgray);
draw_rectangle(_barX, _sanY, _barX + _barW, _sanY + _barH, false);

// Fill (Purple)
draw_set_color(make_color_rgb(128, 0, 128)); 
if (_san_pct > 0) {
    draw_rectangle(_barX, _sanY, _barX + (_barW * _san_pct), _sanY + _barH, false);
}

// Border
draw_set_color(c_white);
draw_rectangle(_barX, _sanY, _barX + _barW, _sanY + _barH, true);

// Text & Values
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_barX + _barW/2, _sanY + _barH/2, string(round(global.sanidade_atual)) + " / " + string(_san_max));

// Label "SAN"
draw_set_halign(fa_right);
draw_text(_barX - 10, _sanY + _barH/2, "SAN");

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
