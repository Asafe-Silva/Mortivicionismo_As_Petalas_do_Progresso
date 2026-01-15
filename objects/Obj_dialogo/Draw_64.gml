if (!inicializar) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var caixa_y = gh - 200;

// Fundo
draw_rectangle_color(0, caixa_y, gw, gh, c_black, c_black, c_black, c_black, false);

draw_set_font(Fnt_dialogo);

// Texto
draw_text_ext(32, caixa_y + 32, texto_grid[# infos.Texto, pagina], 32, gw - 64);

// Nome com fundo
if (texto_grid[# infos.Nome, pagina] != "") {
    var nome = texto_grid[# infos.Nome, pagina];
    var w = string_width(nome) + 12;

    draw_rectangle_color(
        24, caixa_y - 36,
        24 + w, caixa_y - 12,
        c_black, c_black, c_black, c_black, false
    );

    draw_text(30, caixa_y - 32, nome);
}

// Retrato
var spr = texto_grid[# infos.Retrato, pagina];
if (sprite_exists(spr)) {
    draw_sprite_ext(spr, 0, gw - 96, gh - 96, 2, 2, 0, c_white, 1);
}

// Opções (SÓ NO FINAL)
if (tem_escolha && pagina == ds_grid_height(texto_grid) - 1) {

    var base_y = caixa_y - 96; // 👈 DEFINE UMA VEZ

    for (var i = 0; i < array_length(opcoes); i++) {
        var cor = (i == opcao_index) ? c_yellow : c_white;
        draw_set_color(cor);

        draw_text(
            64,
            base_y + i * 24, // 👈 cresce pra baixo
            opcoes[i]
        );
    }

    draw_set_color(c_white);
}
