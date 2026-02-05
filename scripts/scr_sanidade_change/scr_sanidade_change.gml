function scr_sanidade_change(valor) {

    // Proteção: inicializa globals caso Obj_GameState não tenha sido criado ainda
    if (!variable_global_exists("sanidade_atual")) {
        global.sanidade_max = 100;
        global.sanidade_atual = 100;
    }

    global.sanidade_atual += valor;

    if (global.sanidade_atual > global.sanidade_max)
        global.sanidade_atual = global.sanidade_max;

    if (global.sanidade_atual <= 0) {
        // colapso mental / morte
        show_debug_message("COLAPSO PSICOLÓGICO");
        // aqui você pode trocar de sprite, travar controles, etc
    }
}
