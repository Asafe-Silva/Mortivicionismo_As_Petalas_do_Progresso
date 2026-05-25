var _player = instance_nearest(x, y, oPlayerMilitar);

if (instance_exists(_player)) {
	if (point_distance(x, y, _player.x, _player.y) <= 30) {
		if (keyboard_check_pressed(ord("E"))) {
			// Só recarrega se tiver menos que 12
			if (global.walther_ammo < max_ammo) {
				global.walther_ammo = max_ammo;
				show_debug_message("Munição recarregada.");
				} else {
					show_debug_message("Munição já está cheia.");
					} 
			} 
		} 
	}
			