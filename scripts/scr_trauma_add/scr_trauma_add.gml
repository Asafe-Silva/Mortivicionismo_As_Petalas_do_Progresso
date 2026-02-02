function scr_trauma_add(id) {

    if (ds_map_exists(global.traumas, id)) exit;

    var t;

    switch (id) {
        case "TRAUMA_FOGO":
            t = trauma_create(
                id,
                "Transtorno de Estresse Pós-Incêndio",
                "Exposição extrema a fogo e mortes em massa."
            );
            t.sanidade_passiva = -1;
            t.resistencia = 0.5;
            break;

        case "TRAUMA_PEIXE":
            t = trauma_create(
                id,
                "Ictiofobia Traumática",
                "Medo patológico de peixes vivos fora d’água."
            );
            t.sanidade_passiva = -1;
            break;
    }

    ds_map_add(global.traumas, id, t);

    // reduz sanidade máxima
    global.sanidade_max -= 5;
}
