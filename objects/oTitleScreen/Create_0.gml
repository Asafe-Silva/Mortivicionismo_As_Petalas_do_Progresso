

// Verifique se existem salvamentos existentes para configurar a ação principal.
var _has_saves = false;
for (var i = 1; i <= 3; i++) {
    if (file_exists("savegame_slot" + string(i) + ".json")) {
        _has_saves = true;
        break;
    }
}

var _primary_btn = _has_saves ? "CONTINUAR" : "NOVO JOGO";
menu_options = [_primary_btn, "CONFIGURAÇÕES", "CRÉDITOS"];
menu_selected = 0;

// Layout
gui_w = RES_W;
gui_h = RES_H;
display_set_gui_size(gui_w, gui_h);

// Animation / Juice
cursor_offset = 0;
cursor_dir = 1;
time = 0;
