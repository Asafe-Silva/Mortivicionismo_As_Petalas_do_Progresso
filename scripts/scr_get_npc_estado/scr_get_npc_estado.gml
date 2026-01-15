/// scr_get_npc_estado(npc)
function scr_get_npc_estado(npc) {

    if (!ds_map_exists(global.npc_dialogo_estado, npc)) {
        global.npc_dialogo_estado[? npc] = 0;
    }

    return global.npc_dialogo_estado[? npc];
}
