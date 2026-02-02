function scr_sanidade_change(valor) {

    global.sanidade_atual += valor;

    if (global.sanidade_atual > global.sanidade_max)
        global.sanidade_atual = global.sanidade_max;

    if (global.sanidade_atual <= 0) {
        // colapso mental / morte
        show_debug_message("COLAPSO PSICOLÓGICO");
        // aqui você pode trocar de sprite, travar controles, etc
    }
}
