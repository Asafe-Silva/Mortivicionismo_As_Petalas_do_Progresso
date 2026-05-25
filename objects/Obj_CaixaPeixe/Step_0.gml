var _player = instance_nearest(x, y, oPlayerMilitar);

if (instance_exists(_player)) {
	if (point_distance(x, y, _player.x, _player.y) <= 20) {
		if (keyboard_check_pressed(ord("E"))) {
				global.game_message = "Ainda existem peixes vivos aqui.";
				global.game_message_timer = room_speed * 2;
				 
		} 
	} 
}