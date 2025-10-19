if inicializar = true{	
	var _guil = display_get_gui_width();
	var _guia = display_get_gui_height();

	var _xx = 0;
	var _yy = _guia - 200;
	var _c = c_black;
	
	var _sprite = texto_grid[# 1, pagina];
	if (is_undefined(_sprite)) {
	    _sprite = spr_missing; // pode ser um sprite vazio ou padrão
	}
	draw_sprite_ext(_sprite, 0, _guil - 100, _guia, -3, 3, 0, c_white, 1);

	draw_set_font(Fnt_dialogo);

	//Lado Esquerdo
	if texto_grid[# infos.Lado, pagina] == 0{
		draw_rectangle_color(_xx + 200, _yy, _guil, _guia, _c, _c, _c, _c, false);
		draw_text(_xx + 216, _yy - 32, texto_grid[# infos.Nome, pagina]);
		draw_text_ext(_xx + 232, _yy + 32, texto_grid[# infos.Texto, pagina], 32, _guil - 264);
	
		draw_sprite_ext(_sprite, 0, 100, _guia, 3, 3, 0, c_white, 1);
	}//Lado Direito
	else{
		draw_rectangle_color(_xx, _yy, _guil - 200, _guia, _c, _c, _c, _c, false);
		var _stgw = string_width(texto_grid[# infos.Nome, pagina]);
		draw_text(_guil - 216 - _stgw, _yy - 32, texto_grid[# infos.Nome, pagina]);
		draw_text_ext(_xx + 32, _yy + 32, texto_grid[# infos.Texto, pagina], 32, _guil - 264);
	
		draw_sprite_ext(_sprite, 0, _guil - 100, _guia, -3, 3, 0, c_white, 1);
	}
}