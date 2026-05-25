if (global.game_message_timer > 0) { 
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle); 
	
	draw_set_color(c_black); 
	draw_rectangle(180, 480, 780, 520, false);
	
	draw_set_color(c_white); 
	
	draw_text(480, 500, global.game_message); 
}