
// Configuração do inventário
maxSlots = 63;
inventorySlots = array_create(maxSlots, undefined);

/// @function InventoryAdd(_itemStruct)
/// @descricao Adiciona um item no primeiro slot disponível.
/// @param {Struct} _itemStruct Estrutura do item a ser adicionada.
/// @returns {Bool} Retorna true se adicionado, false se o inventário estiver cheio.
InventoryAdd = function(_itemStruct) {
    if (!is_struct(_itemStruct)) {
        show_debug_message("InventoryAdd Error: struct de item inválida.");
        return false;
    }

    for (var i = 0; i < maxSlots; i++) {
        if (inventorySlots[i] == undefined) {
            inventorySlots[i] = _itemStruct;
            show_debug_message("Item adicionado: " + _itemStruct.name + " no slot " + string(i));
            return true;
        }
    }
    
    show_debug_message("Inventário cheio! Não foi possível adicionar " + _itemStruct.name);
    return false;
}

/// @function InventoryRemove(_index)
/// @descricao Remove o item no índice especificado.
/// @param {Real} _index Índice do slot a remover.
InventoryRemove = function(_index) {
    if (_index >= 0 && _index < maxSlots) {
        inventorySlots[_index] = undefined;
        show_debug_message("Item removido no slot " + string(_index));
    }
}

/// @function InventoryHasItem(_itemId)
/// @descricao Verifica se o inventário contém um item com o ID fornecido.
/// @param {String} _itemId ID único do item a procurar.
/// @returns {Bool} True se encontrado, false caso contrário.
InventoryHasItem = function(_itemId) {
    for (var i = 0; i < maxSlots; i++) {
        var _item = inventorySlots[i];
        if (_item != undefined && _item.id == _itemId) {
            return true;
        }
    }
    return false;
}

// Mensagem de debug de inicialização
show_debug_message("Obj_InventoryManager inicializado com " + string(maxSlots) + " slots.");

// UI State
menuActive = false;
global.game_paused = false;

// Tabs System
enum MENU_TABS {
    RESUMO,
    SANIDADE,
    INVENTARIO,
    DIALOGOS,
    MORAL,
    CONFIG
}

current_tab = MENU_TABS.INVENTARIO;

// --- Sistema de Traumas ---
function Trauma(_id, _name, _desc, _sprite, _type) constructor {
    id = _id;
    name = _name;
    description = _desc;
    sprite = _sprite;
    type = _type; // "maior" or "menor"
}

traumas_maiores = [];
traumas_menores = [];

// Trauma de exemplo (placeholder)
var _trm = new Trauma("trm_peixe", "Peixe Vivo fora d'água", "Você se sente como este peixe miserável, sem ar...\nSe não se afastar, pode sufocar.", -1, "maior");
array_push(traumas_maiores, _trm);

// --- Sistema de Medalhas ---
function Medal(_id, _name, _desc, _sprite) constructor {
    id = _id;
    name = _name;
    description = _desc;
    sprite = _sprite;
}

// 7 columns * 3 rows = 21 slots
medals_slots = array_create(21, undefined);

// Medalha de exemplo (placeholder)
var _mdl = new Medal("mdl_test", "Honra ao Mérito", "Condecorado por bravura excepcional em campo de batalha sob fogo inimigo.", -1);
medals_slots[0] = _mdl;
