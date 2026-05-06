
// Interaction Logic
var _player = instance_nearest(x, y, oPlayerMilitar);

if (instance_exists(_player) && point_distance(x, y, _player.x, _player.y) <= pickupRange) {
    if (keyboard_check_pressed(ord("E"))) {
        
        var _invManager = instance_find(oInventoryManager, 0);
        
        if (_invManager != noone) {
            
            // Retrieve item struct
            var _itemStruct = global.item_database[$ itemId];
            
            if (_itemStruct != undefined) {
                // Try add
                if (_invManager.InventoryAdd(_itemStruct)) {
                    
                    // Specific logic (e.g. unlock weapon)
                    OnCollect();
                    
                    show_debug_message("Collected: " + itemId);
                    instance_destroy();
                } else {
                    show_debug_message("Inventory Full");
                }
            } else {
                show_debug_message("Error: Item ID '" + itemId + "' not found in database.");
            }
        } else {
             show_debug_message("Error: oInventoryManager instance not found.");
        }
    }
}
