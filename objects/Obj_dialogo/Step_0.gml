var avancar =
    keyboard_check_pressed(ord("E")) ||
    keyboard_check_pressed(vk_space) ||
    mouse_check_button_pressed(mb_left);

/// ───────── INICIALIZAÇÃO ─────────
if (!inicializar) {
    scr_textos(npc_nome);
    iniciar_digitacao();
    inicializar = true;
}

/// ───────── DIGITAÇÃO ─────────
if (!texto_terminou) {

    char_index++;

    if (char_index >= string_length(texto_completo)) {
        char_index = string_length(texto_completo);
        texto_terminou = true;

        // ATIVA ESCOLHA APENAS SE REALMENTE EXISTIR
        if (tem_escolha
        && pagina == ds_grid_height(texto_grid) - 1
        && array_length(opcoes) > 0) {

            escolha_ativa = true;
            opcao_index = 0;
        }
    }

    texto_visivel = string_copy(texto_completo, 1, char_index);

    // E / ESPAÇO COMPLETA TEXTO
    if (avancar) {
        texto_visivel = texto_completo;
        texto_terminou = true;
    }

    exit;
}

/// ───────── ESCOLHAS ─────────
if (escolha_ativa) {

    if (keyboard_check_pressed(vk_up))   opcao_index--;
    if (keyboard_check_pressed(vk_down)) opcao_index++;

    opcao_index = clamp(opcao_index, 0, array_length(opcoes) - 1);

    if (avancar) {
        escolha_ativa = false;
        scr_escolha_resultado(opcao_index);
    }

    exit;
}

/// ───────── AVANÇO / SAÍDA ─────────
if (avancar) {

    if (pagina < ds_grid_height(texto_grid) - 1) {
        pagina++;
        iniciar_digitacao();
    }
    else {
        global.dialogo = false;
        global.dialogo_lock = true;
        instance_destroy();
    }
}
