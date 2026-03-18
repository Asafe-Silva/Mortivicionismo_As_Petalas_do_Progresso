live_auto_call

// Input lock during transitions
if (instance_exists(oTransition)) exit;

// Input
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _enter = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (_up) {
    menu_selected--;
    if (menu_selected < 0) menu_selected = array_length(menu_options) - 1;
}

if (_down) {
    menu_selected++;
    if (menu_selected >= array_length(menu_options)) menu_selected = 0;
}

if (_enter) {
    switch(menu_selected) {
        case 0: // NOVO JOGO
            var _t = instance_create_depth(0, 0, -9999, oTransition);
            _t.target_room = rmInit;
            break;
        case 1: // CONTINUAR
            var _t = instance_create_depth(0, 0, -9999, oTransition);
            _t.target_room = rm_SaveSlots; 
            break;
        case 2: // CONFIGURAÇÕES
            show_debug_message("CONFIGURAÇÕES selecionado (A fazer)");
            break;
        case 3: // CRÉDITOS
            show_debug_message("CRÉDITOS selecionado (A fazer)");
            break;
    }
}

// Animation
// Fixed shaking cursor: removed exponential time increment logic, just using current_time smoothly
cursor_offset = sin(current_time / 150) * 5;
