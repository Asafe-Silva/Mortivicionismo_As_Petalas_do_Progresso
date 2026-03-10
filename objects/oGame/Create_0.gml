// --- System Configuration ---
persistent = true;

// Initialize missing globals for Save/Load
global.player_hp = 100;
global.player_hp_max = 100; // Adding max hp
if (!variable_global_exists("sanidade_atual")) global.sanidade_atual = 100;

// Lerp variables for smooth HUD
hp_lerp = global.player_hp;
sanity_lerp = global.sanidade_atual;

// Initialize Alignment / Moral globals
global.moral_politica = 0; // -100 (Militar) -> +100 (Revolucionário)
global.moral_etica = 0;    // -100 (Má Pessoa) -> +100 (Boa Pessoa)

// Prevent missing group crash
if (!audio_group_is_loaded(audiogroup_bgm)) audio_group_load(audiogroup_bgm);
if (!audio_group_is_loaded(audiogroup_sfx)) audio_group_load(audiogroup_sfx);

// Ensure MACROS are read or use defaults if script execution order is weird (it shouldn't be)
var _w = 960; 
var _h = 540;
if (variable_global_exists("RES_W")) _w = RES_W; // Macros are pre-processor, so this check is redundant but safe if macro was a var
// Actually macros replace text, so just use them directly if possible. 
// GML Macros: #macro RES_W 960

surface_resize(application_surface, RES_W, RES_H);
display_set_gui_size(RES_W, RES_H);
window_set_size(RES_W, RES_H);

// Center Window
var _displayW = display_get_width();
var _displayH = display_get_height();
window_set_position((_displayW - RES_W) / 2, (_displayH - RES_H) / 2);
