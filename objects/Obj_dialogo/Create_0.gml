// Obj_dialogo - Create
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