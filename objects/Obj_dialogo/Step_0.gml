// Inicialização
if inicializar == false{
	scr_texto();
	inicializar = true;
}

if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape)) {
    if (pagina < ds_grid_height(texto_grid) - 1) {
        pagina++;
    } else {
        global.dialogo = false; // libera para novo diálogo
        instance_destroy();
    }
}
