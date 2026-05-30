live_auto_call

// Avança o scroll dos créditos
scroll_y += scroll_speed;

// Voltar com ESCAPE
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    var _t = instance_create_depth(0, 0, -9999, oTransition);
    _t.target_room = rm_TitleScreen;
}
