/// @function InitGlobals()
/// @descricao Inicializa todas as variáveis globais necessárias para a estrutura do jogo.
/// Pode ser chamada múltiplas vezes com segurança (usa variable_global_exists).
function InitGlobals() {
    if (!variable_global_exists("game_initialized") || !global.game_initialized) {
        // 1. Sistema de Diálogo
        if (!variable_global_exists("dialogo")) global.dialogo = false;
        if (!variable_global_exists("dialogo_lock")) global.dialogo_lock = false;

        // 2. Legacy Inventory (DS List)
        if (!variable_global_exists("inv")) global.inv = ds_list_create();
        if (!variable_global_exists("inv_peso_atual")) global.inv_peso_atual = 0;
        if (!variable_global_exists("inv_peso_max")) global.inv_peso_max = 40;

        // 3. Sistema de Sanidade (Traumas)
        if (!variable_global_exists("sanidade_atual")) global.sanidade_atual = 100;
        if (!variable_global_exists("sanidade_max")) global.sanidade_max = 100;
        if (!variable_global_exists("low_sanity")) global.low_sanity = false;

        // Função para modificar sanidade de forma segura
        global.ModifySanity = function(_amount) {
            global.sanidade_atual = clamp(global.sanidade_atual + _amount, 0, global.sanidade_max);
            
            // Low Sanity Flag (< 20%)
            global.low_sanity = (global.sanidade_atual <= (global.sanidade_max * 0.2));
            
            show_debug_message("Sanidade: " + string(global.sanidade_atual) + "/" + string(global.sanidade_max));
        }

        // 4. Traumas Map
        if (!variable_global_exists("traumas")) global.traumas = ds_map_create();

        // 5. Estado da Arma (Walther P38)
        if (!variable_global_exists("have_walther")) global.have_walther = false;
        if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = 6;
        if (!variable_global_exists("walther_ammo")) global.walther_ammo = global.walther_max_ammo;
        if (!variable_global_exists("walther_cooldown")) global.walther_cooldown = 0;
        
        // 6. Estado geral do jogo
        if (!variable_global_exists("game_paused")) global.game_paused = false;
        if (!variable_global_exists("player_hp")) global.player_hp = 100;
        if (!variable_global_exists("is_loading_game")) global.is_loading_game = false;

        global.game_initialized = true;
        show_debug_message("Variáveis globais inicializadas.");
    }
    
    // 7. Garante que objetos de sistema existam (crítico para carregar a partir do menu)
    if (!instance_exists(oControl)) {
        show_debug_message("Objeto de controle do sistema ausente. Criando...");
        instance_create_depth(0, 0, 0, oControl);
    }
}

/// @function ResetGameSession()
/// @descricao Restaura todas as variáveis de jogo para seus valores padrão.
/// Útil para iniciar um novo jogo ou voltar ao menu título.
function ResetGameSession() {
    InitGlobals(); // Ensure they are at least initialized
    
    // Reset stats
    global.sanidade_atual = 100;
    global.player_hp = 100;
    global.dialogo = false;
    global.game_paused = false;
    
    // Clear data structures
    if (variable_global_exists("inv")) ds_list_clear(global.inv);
    if (variable_global_exists("traumas")) ds_map_clear(global.traumas);
    
    // Reset weapon
    global.have_walther = false;
    global.walther_ammo = global.walther_max_ammo;
    
    show_debug_message("Sessão de jogo reiniciada para valores padrão.");
}
