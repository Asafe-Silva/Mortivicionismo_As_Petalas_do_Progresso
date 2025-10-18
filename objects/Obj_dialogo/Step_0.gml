// Obj_dialogo - Step

// Inicializa o array de texto uma vez (com segurança)
if (!inicializar) {
    // usa o script que retorna o array (passa npc_nome)
    texto = scr_textos(npc_nome); // agora texto é o array retornado
    // segurança: se por algum motivo veio vazio, coloca mensagem padrão
    if (!is_array(texto) || array_length(texto) == 0) {
        texto = ["Sem diálogo disponível."];
    }
    pagina = 0;
    inicializar = true;
}

// Avança a página com clique do mouse OU tecla E
if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("R"))) {
    if (pagina < array_length(texto) - 1) {
        pagina++;
    } else {
		global.dialogo = false;	// <-- libera para abrir novo diálogo
        instance_destroy();
    }
}

