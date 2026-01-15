/// Obj_dialogo - Create
npc_atual = "";
npc_nome = "";
pagina = 0;
inicializar = false;

/// Memória de diálogo por NPC
if (!variable_global_exists("npc_dialogo_estado")) {
    global.npc_dialogo_estado = ds_map_create();
}

// GRID: Texto | Retrato | Lado | Nome
texto_grid = ds_grid_create(4, 0);

// Sistema de escolhas
opcoes = [];
tem_escolha = false;
escolha_ativa = false; // ✅ CORREÇÃO AQUI
opcao_index = 0;
dialog_state = 0;


// Enum para facilitar leitura
enum infos {
    Texto,
    Retrato,
    Lado,
    Nome
}

// Segurança
if (!variable_global_exists("dialogo")) global.dialogo = true;
