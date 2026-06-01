live_auto_call

slot_data = array_create(3, undefined);

for (var i = 0; i < 3; i++) {
    var _data = GetSaveMetadata(i + 1);
    if (_data != undefined) {
        slot_data[i] = _data;
    }
}

// UI State
selected_slot = 0; // 0, 1, 2
selected_action = 0; // 0: RENOMEAR, 1: ENTRAR, 2: APAGAR (only if slot_data is not undefined)

// Async tracking
async_rename_dialog = -1;
async_rename_slot = -1;
