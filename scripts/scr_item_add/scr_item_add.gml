function scr_item_add(item) {

    ds_list_add(global.inv, item);
    global.inv_peso_atual += item.peso;

    // impacto emocional imediato
    if (item.valor_emocional != 0) {
        scr_sanidade_change(item.valor_emocional);
    }

    // item corrompido
    if (item.corrompido && item.origem_violenta) {
        scr_sanidade_change(-5);
    }

    // gatilho de trauma
    if (item.trauma_associado != "") {
        scr_trauma_add(item.trauma_associado);
    }
}
