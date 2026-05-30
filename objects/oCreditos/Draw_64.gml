live_auto_call

// Fundo preto para legibilidade
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

// Configurações de desenho de texto
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(Fnt_dialogo);
draw_set_color(c_white);

var _cx = room_width / 2;
var _start_y = 60 - scroll_y;
var _line_h = 28;

for (var i = 0; i < array_length(credits); i++) {
    draw_text(_cx, _start_y + (i * _line_h), credits[i]);
}
