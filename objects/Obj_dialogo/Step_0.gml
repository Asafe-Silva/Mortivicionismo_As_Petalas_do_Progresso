var avancar =
    keyboard_check_pressed(ord("E")) ||
    keyboard_check_pressed(vk_space) ||
    mouse_check_button_pressed(mb_left);

if (avancar && !tem_escolha) {

    if (!texto_terminou) {
        // PULA A DIGITAÇÃO
        texto_visivel = texto_completo;
        texto_terminou = true;
    }
    else {
        pagina++;
        iniciar_digitacao();
    }
}

if (!texto_terminou) {

    tempo_letra++;

    var delay = velocidade_base;

    var letra = string_char_at(texto_completo, char_index + 1);

    // ───── VARIAÇÕES DE RITMO ─────

    if (letra == "." || letra == "?" || letra == "!") {
        delay = 12; // pausa forte
    }
    else if (letra == ",") {
        delay = 6;
    }
    else if (letra == " ") {
        delay = 2;
    }

    // Palavras que "pesam"
    var trecho = string_copy(texto_completo, char_index - 5, 10);
    if (string_pos("respeito", trecho) > 0) {
        delay = 5;
    }

    // ───── DIGITAÇÃO ─────

    if (tempo_letra >= delay) {

        texto_visivel += letra;
        char_index++;
        tempo_letra = 0;

        // 🎵 GANCHO DE SOM (VOCÊ IMPLEMENTA)
        // audio_play_sound(snd_dialogo, 0, false);
    }

    if (char_index >= string_length(texto_completo)) {
        texto_terminou = true;
    }
}


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
