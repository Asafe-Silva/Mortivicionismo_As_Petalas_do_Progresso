// Obj_dialogo - Draw GUI
var _guil = display_get_gui_width();
var _guia = display_get_gui_height();
var _xx = 0;
var _yy = _guia - 200;
var _c = c_black;

draw_set_font(Fnt_dialogo);
draw_set_color(c_black);
draw_rectangle_color(_xx, _yy, _guil, _guia, _c, _c, _c, _c, false);

// Só desenha se texto existir e pagina for válida
if (is_array(texto) && array_length(texto) > 0 && pagina >= 0 && pagina < array_length(texto)) {
    draw_set_color(c_white);
    draw_text_ext(_xx + 32, _yy + 32, texto[pagina], 32, _guil - 64);
}
