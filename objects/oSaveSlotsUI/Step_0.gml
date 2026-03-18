live_auto_call

if (instance_exists(oTransition)) exit;
if (async_rename_dialog != -1) exit;

var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _enter = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _back = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

if (_back) {
    var _t = instance_create_depth(0, 0, -9999, oTransition);
    _t.target_room = rm_TitleScreen;
    exit;
}

// Navigation between slots
if (_left) {
    selected_slot--;
    if (selected_slot < 0) selected_slot = 2;
    selected_action = 0; // reset action
}

if (_right) {
    selected_slot++;
    if (selected_slot > 2) selected_slot = 0;
    selected_action = 0; // reset action
}

// If slot has data, navigate actions
if (slot_data[selected_slot] != undefined) {
    if (_up) {
        selected_action--;
        if (selected_action < 0) selected_action = 2;
    }
    if (_down) {
        selected_action++;
        if (selected_action > 2) selected_action = 0;
    }
}

// Interaction
if (_enter) {
    var _slot_id = selected_slot + 1;
    
    if (slot_data[selected_slot] == undefined) {
        // Empty slot - Start new game and save it immediately to populate slot metadata
        SaveGame(_slot_id, "Novo Jogo " + string(_slot_id));
        var _t = instance_create_depth(0, 0, -9999, oTransition);
        _t.target_room = rmInit;
        
        // Setup globals for new game
        global.sanidade_atual = 100;
        global.player_hp = 100;
        // The transition will handle rmInit which handles player spawning natively.
    } else {
        switch(selected_action) {
            case 0: // RENOMEAR
                async_rename_slot = _slot_id;
                async_rename_dialog = get_string_async("Renomear Save:", slot_data[selected_slot].save_name);
                break;
            case 1: // ENTRAR
                var _t = instance_create_depth(0, 0, -9999, oTransition);
                // First load the game state data into globals
                LoadGame(_slot_id);
                // LoadGame() natively does room_goto, but oTransition will overwrite room transition logic nicely or we can let LoadGame handle it if we modify it.
                // For simplicity, LoadGame sets global.is_loading_game and handles the target room.
                // We will just create oTransition and let LoadGame move us.
                // Actually, LoadGame already calls room_goto, so if we create Transition we must pass the target room properly.
                break;
            case 2: // APAGAR
                if (file_exists("savegame_slot" + string(_slot_id) + ".json")) {
                    file_delete("savegame_slot" + string(_slot_id) + ".json");
                }
                slot_data[selected_slot] = undefined;
                selected_action = 0;
                break;
        }
    }
}
