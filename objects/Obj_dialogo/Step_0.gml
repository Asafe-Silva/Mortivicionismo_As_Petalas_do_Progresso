/// Inicialização do diálogo
if (!inicializar) {
    scr_textos(npc_nome);
    inicializar = true;
}

/// Avançar diálogo (somente se NÃO estiver em escolha)
if (!tem_escolha) {
    if (keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_left)) {
        if (pagina < ds_grid_height(texto_grid) - 1) {
            pagina++;
        } else {
            global.dialogo = false;
            instance_destroy();
        }
    }
}

/// Navegação das escolhas
if (tem_escolha) {
    if (keyboard_check_pressed(vk_up))   opcao_index = max(0, opcao_index - 1);
    if (keyboard_check_pressed(vk_down)) opcao_index = min(array_length(opcoes) - 1, opcao_index + 1);

    if (keyboard_check_pressed(vk_enter)) {
        scr_escolha_resultado(opcao_index);
    }
}
