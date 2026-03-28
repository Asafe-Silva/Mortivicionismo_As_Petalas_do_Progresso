/// @function SaveGame(slot_id, save_name)
/// @description Saves the game state to a JSON file based on slot index.
function SaveGame(_slot_id = 1, _save_name = "Save") {
    var _filename = "savegame_slot" + string(_slot_id) + ".json";
    var _saveData = {
        save_name: _save_name,
        room_name: room_get_name(room),
        player_x: 0,
        player_y: 0,
        sanidade_atual: 100,
        player_hp: 100,
        inventory: []
    };

    // Get Player Position if exists
    if (instance_exists(oPlayerMilitar)) {
        _saveData.player_x = oPlayerMilitar.x;
        _saveData.player_y = oPlayerMilitar.y;
    }

    // Get Globals
    if (variable_global_exists("sanidade_atual")) _saveData.sanidade_atual = global.sanidade_atual;
    if (variable_global_exists("player_hp")) _saveData.player_hp = global.player_hp;

    // Get Inventory
    if (instance_exists(oInventoryManager)) {
        // Deep copy might be needed depending on how structs work, 
        // but json_stringify handles nested structs automatically.
        _saveData.inventory = oInventoryManager.inventorySlots;
    }

    // Convert to JSON
    var _jsonString = json_stringify(_saveData);
    
    // Save to File
    var _file = file_text_open_write(_filename);
    if (_file != -1) {
        file_text_write_string(_file, _jsonString);
        file_text_close(_file);
        show_debug_message("Game Saved to " + _filename);
    } else {
        show_debug_message("Failed to open save file for writing.");
    }
}

/// @function LoadGame(slot_id)
/// @description Loads the game state from a JSON file.
function LoadGame(_slot_id = 1) {
    InitGlobals();
    var _filename = "savegame_slot" + string(_slot_id) + ".json";
    
    if (!file_exists(_filename)) {
        show_debug_message("No save file found.");
        return;
    }

    var _file = file_text_open_read(_filename);
    var _jsonString = "";
    
    if (_file != -1) {
        while (!file_text_eof(_file)) {
            _jsonString += file_text_read_string(_file);
            file_text_readln(_file);
        }
        file_text_close(_file);
    } else {
        show_debug_message("Failed to read save file.");
        return;
    }

    // Parse JSON
    try {
        var _loadData = json_parse(_jsonString);
        
        // Restore Globals
        if (variable_struct_exists(_loadData, "sanidade_atual")) global.sanidade_atual = _loadData.sanidade_atual;
        if (variable_struct_exists(_loadData, "player_hp")) global.player_hp = _loadData.player_hp;
        
        // Restore Inventory
        if (instance_exists(oInventoryManager) && variable_struct_exists(_loadData, "inventory")) {
            // Reconstruct the array of structs
            oInventoryManager.inventorySlots = _loadData.inventory;
            
            // Re-instantiate Item structs if needed, although json_parse creates generic structs.
            // If methods are needed on items, we must map them. For now simple structs might suffice.
            // Usually we'd iterate and recreate specific constructors: 
            /*
            for (var i = 0; i < array_length(_loadData.inventory); i++) {
                var _itemData = _loadData.inventory[i];
                if (_itemData != -1) {
                    // Find in database by name/id and reconstruct to get functions back
                }
            }
            */
            // Let's assume generic structs work for current inventory logic (drawing/checking), 
            // otherwise we'll refine this in the verification step.
        }

        // Room Transition / Position Fix
        if (variable_struct_exists(_loadData, "room_name")) {
            var _targetRoom = asset_get_index(_loadData.room_name);
            
            if (_targetRoom != -1) {
                // If same room, just move
                if (room == _targetRoom) {
                    if (instance_exists(oPlayerMilitar)) {
                        oPlayerMilitar.x = _loadData.player_x;
                        oPlayerMilitar.y = _loadData.player_y;
                    }
                } else {
                    // Different room - setup globals for transition
                    global.load_target_x = _loadData.player_x;
                    global.load_target_y = _loadData.player_y;
                    global.is_loading_game = true; // flag to apply position in Room Start
                    
                    if (instance_exists(oTransition)) {
                        oTransition.target_room = _targetRoom;
                    } else {
                        room_goto(_targetRoom);
                    }
                }
            }
        }
        
        show_debug_message("Game Loaded successfully.");

    } catch(_error) {
        show_debug_message("Error parsing save file: " + string(_error));
    }
}

/// @function GetSaveMetadata(slot_id)
/// @description Retrieves save details without applying state (for UI menus).
function GetSaveMetadata(_slot_id) {
    var _filename = "savegame_slot" + string(_slot_id) + ".json";
    if (!file_exists(_filename)) return undefined;
    
    var _file = file_text_open_read(_filename);
    var _jsonString = "";
    if (_file != -1) {
        while (!file_text_eof(_file)) {
            _jsonString += file_text_read_string(_file);
            file_text_readln(_file);
        }
        file_text_close(_file);
        try {
            return json_parse(_jsonString);
        } catch(_e) {
            return undefined;
        }
    }
    return undefined;
}
