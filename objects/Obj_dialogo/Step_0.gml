var avancar =
    keyboard_check_pressed(ord("E")) ||
    keyboard_check_pressed(vk_space) ||
    mouse_check_button_pressed(mb_left);


/// Inicialização
if (!inicializar) {
    scr_textos(npc_nome);
    inicializar = true;
}


/// TEXTO NORMAL
if (!escolha_ativa) {

    if (avancar) {

        // ainda há texto
        if (pagina < ds_grid_height(texto_grid) - 1) {
            pagina++;
        }

        // acabou o texto
        else {

            // existe escolha? ativa agora
            if (tem_escolha) {
                escolha_ativa = true;
                opcao_index = 0;
            }

            // senão encerra diálogo
            else {
                global.dialogo = false;
                global.dialogo_lock = true;
                instance_destroy();
                exit;
            }
        }
    }
}


/// ESCOLHAS
if (escolha_ativa) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        opcao_index = max(0, opcao_index - 1);

    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        opcao_index = min(array_length(opcoes) - 1, opcao_index + 1);

    if (keyboard_check_pressed(vk_enter)) {
        escolha_ativa = false;
        scr_escolha_resultado(opcao_index);
    }
}
