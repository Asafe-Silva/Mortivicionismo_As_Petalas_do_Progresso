/// Obj_dialogo - Create

npc_nome = "";
pagina = 0;
inicializar = false;

// GRID: Texto | Retrato | Lado | Nome
texto_grid = ds_grid_create(4, 0);

// Sistema de escolhas
tem_escolha = false;
opcao_index = 0;
opcoes = [];

// Enum para facilitar leitura
enum infos {
    Texto,
    Retrato,
    Lado,
    Nome
}

// Segurança
if (!variable_global_exists("dialogo")) global.dialogo = true;