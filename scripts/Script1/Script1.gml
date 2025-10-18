/// scr_textos(npc_name)
function scr_textos(npc_name) {
    var t = []; // array local de falas

    switch (npc_name) {
        case "Gatogirl":
            array_push(t, "Eu amo meu namorado");
            array_push(t, "De hoje para sempre");
            array_push(t, "Amen!");
            break;

        default:
            array_push(t, "…");
            break;
    }

    return t;
}

