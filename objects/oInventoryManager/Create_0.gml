
// Configuration
maxSlots = 12;
inventorySlots = array_create(maxSlots, undefined);

/// @function InventoryAdd(_itemStruct)
/// @description Adds an item to the first available slot.
/// @param {Struct} _itemStruct The item to add.
/// @returns {Bool} True if added, false if inventory is full.
InventoryAdd = function(_itemStruct) {
    if (!is_struct(_itemStruct)) {
        show_debug_message("InventoryAdd Error: Invalid item struct.");
        return false;
    }

    for (var i = 0; i < maxSlots; i++) {
        if (inventorySlots[i] == undefined) {
            inventorySlots[i] = _itemStruct;
            show_debug_message("Item Added: " + _itemStruct.name + " at slot " + string(i));
            return true;
        }
    }
    
    show_debug_message("Inventory Full! Could not add " + _itemStruct.name);
    return false;
}

/// @function InventoryRemove(_index)
/// @description Removes the item at the specified index.
/// @param {Real} _index The slot index to remove.
InventoryRemove = function(_index) {
    if (_index >= 0 && _index < maxSlots) {
        inventorySlots[_index] = undefined;
        show_debug_message("Item removed at slot " + string(_index));
    }
}

/// @function InventoryHasItem(_itemId)
/// @description Checks if the inventory contains an item with the given ID.
/// @param {String} _itemId The unique ID of the item to check.
/// @returns {Bool} True if found, false otherwise.
InventoryHasItem = function(_itemId) {
    for (var i = 0; i < maxSlots; i++) {
        var _item = inventorySlots[i];
        if (_item != undefined && _item.id == _itemId) {
            return true;
        }
    }
    return false;
}

// Debug initialization message
show_debug_message("Obj_InventoryManager initialized with " + string(maxSlots) + " slots.");

// UI State
menuActive = false;
global.game_paused = false;
