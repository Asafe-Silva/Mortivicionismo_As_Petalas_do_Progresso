live_auto_call

var _id = ds_map_find_value(async_load, "id");
if (_id == async_rename_dialog) {
    if (ds_map_find_value(async_load, "status")) {
        var _new_name = ds_map_find_value(async_load, "result");
        if (_new_name != "") {
            // Find current data
            var _idx = async_rename_slot - 1;
            if (slot_data[_idx] != undefined) {
                // To rename, we must read the whole JSON, change the name, and rewrite
                var _filename = "savegame_slot" + string(async_rename_slot) + ".json";
                var _file = file_text_open_read(_filename);
                if (_file != -1) {
                    var _jsonStr = "";
                    while (!file_text_eof(_file)) {
                        _jsonStr += file_text_read_string(_file);
                        file_text_readln(_file);
                    }
                    file_text_close(_file);
                    
                    var _data = json_parse(_jsonStr);
                    _data.save_name = _new_name;
                    
                    var _outFile = file_text_open_write(_filename);
                    if (_outFile != -1) {
                        file_text_write_string(_outFile, json_stringify(_data));
                        file_text_close(_outFile);
                    }
                    
                    // Update UI copy
                    slot_data[_idx].save_name = _new_name;
                }
            }
        }
    }
    async_rename_dialog = -1;
    async_rename_slot = -1;
}
