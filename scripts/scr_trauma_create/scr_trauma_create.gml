/// trauma_create(id, titulo, descricao)
function trauma_create(id, titulo, descricao) {
    var t = ds_map_create();
    ds_map_add(t, "id", id);
    ds_map_add(t, "titulo", titulo);
    ds_map_add(t, "descricao", descricao);
    ds_map_add(t, "ativo", true);
    ds_map_add(t, "sanidade_passiva", 0);
    ds_map_add(t, "resistencia", 1);
    ds_map_add(t, "gatilho", ""); // nome de script gatilho opcional
    ds_map_add(t, "tempo", 0);
    return t;
}
