function scr_trauma_update() {

    var keys = ds_map_keys(global.traumas);

    for (var i = 0; i < array_length(keys); i++) {
        var t = global.traumas[? keys[i]];

        if (!t.ativo) continue;

            // perda passiva (aplicada por passo)
            if (t.sanidade_passiva != 0) {
                scr_sanidade_change(t.sanidade_passiva);
            }
    }
}
