if (!inicializar) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var caixa_y = gh - 200;
draw_rectangle_color(0, caixa_y, gw, gh, c_black, c_black, c_black, c_black, false);

draw_set_font(Fnt_dialogo);

// Texto
draw_text_ext(32, caixa_y + 32, texto_grid[# infos.Texto, pagina], 32, gw - 64);

// Nome
if (texto_grid[# infos.Nome, pagina] != "") {
    draw_text(32, caixa_y - 24, texto_grid[# infos.Nome, pagina]);
}

// Retrato
var spr = texto_grid[# infos.Retrato, pagina];
if (sprite_exists(spr)) {
    draw_sprite_ext(spr, 0, gw - 96, gh - 96, 2, 2, 0, c_white, 1);
}

// Desenho das escolhas
if (tem_escolha) {
    for (var i = 0; i < array_length(opcoes); i++) {
        var cor = (i == opcao_index) ? c_yellow : c_white;
        draw_set_color(cor);
        draw_text(64, caixa_y - 64 - i * 24, opcoes[i].texto);
    }
    draw_set_color(c_white);
	
	if (tem_escolha && pagina == ds_grid_height(texto_grid) - 1) {
	    for (var i = 0; i < array_length(opcoes); i++) {
	        var cor = (i == indice_escolha) ? c_yellow : c_white;
	        draw_set_color(cor);
	        draw_text(_xx + 232, _yy + 96 + i * 24, opcoes[i]);
	    }
	}
}
