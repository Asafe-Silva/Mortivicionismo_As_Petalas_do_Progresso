var _player = instance_nearest(x, y, oPlayerMilitar);

if (instance_exists(_player)) {
	if (point_distance(x, y, _player.x, _player.y) <= 20) {
		if (keyboard_check_pressed(ord("E"))) {
			// Só recarrega se tiver menos que 12
			if (global.walther_ammo < max_ammo) {
				global.walther_ammo = max_ammo;
				
				global.game_message = "Munição recarregada."; 
				global.game_message_timer = room_speed * 2;
				} else {
					show_debug_message("Munição já está cheia.");
					global.game_message = "Munição já está cheia.";
					global.game_message_timer = room_speed * 2;
					} 
			} 
		} 
	}
			