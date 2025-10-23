// Obj_dialogo - Create
if (!variable_instance_exists(id, "npc_nome")) npc_nome = "";
if (!variable_instance_exists(id, "retrato")) retrato = spr_missing;
if (!variable_instance_exists(id, "texto")) texto = "";
if (!variable_global_exists("dialogo")) global.dialogo = false;

// Garante que o sprite padrão exista, senão evita erro
if (!sprite_exists(spr_missing)) {
    global.spr_missing_fallback = -1;
} else {
    global.spr_missing_fallback = spr_missing;
}


npc_nome = "";        // vai ser sobrescrito quando criado pelo jogador
texto_grid = ds_grid_create(4,0);	//4 colubas, 0 linhas
pagina = 0;
inicializar = true;

enum infos{
	Texto, 
	Retrado,
	Lado,
	Nome,
}