
/// @function Item(_id, _name, _description, _sprite, _type, _weight, _is_corrupted)
/// @descricao Construtor base para todos os itens.
/// @param {String} _id Identificador único do item.
/// @param {String} _name Nome exibido do item.
/// @param {String} _description Texto descritivo do item.
/// @param {Asset.GMSprite} _sprite Sprite do item.
/// @param {String} _type Tipo do item (ex.: "Weapon", "Consumable", "Key").
/// @param {Real} _weight Peso do item.
/// @param {Bool} _is_corrupted Indica se o item afeta a sanidade.
function Item(_id, _name, _description, _sprite, _type, _weight, _is_corrupted) constructor {
    id = _id;
    name = _name;
    description = _description;
    sprite = _sprite;
    type = _type;
    weight = _weight;
    is_corrupted = _is_corrupted;

    static GetDescription = function() {
        return description;
    }
}

/// @function Weapon(_id, _name, _description, _sprite, _weight, _is_corrupted, _damage, _range, _ammo_capacity)
/// @descricao Construtor para armas, herda de `Item`.
/// @param {String} _id Identificador único da arma.
/// @param {String} _name Nome exibido da arma.
/// @param {String} _description Texto descritivo da arma.
/// @param {Asset.GMSprite} _sprite Sprite da arma.
/// @param {Real} _weight Peso da arma.
/// @param {Bool} _is_corrupted Indica se a arma afeta a sanidade.
/// @param {Real} _damage Dano causado pela arma.
/// @param {Real} _range Alcance efetivo da arma.
/// @param {Real} _ammo_capacity Capacidade máxima de munição.
function Weapon(_id, _name, _description, _sprite, _weight, _is_corrupted, _damage, _range, _ammo_capacity) : Item(_id, _name, _description, _sprite, "Weapon", _weight, _is_corrupted) constructor {
    damage = _damage;
    range = _range;
    ammo_capacity = _ammo_capacity;
}

/// @function Consumable(_id, _name, _description, _sprite, _weight, _is_corrupted, _heal_value, _effect_description)
/// @descricao Construtor para consumíveis, herda de `Item`.
/// @param {String} _id Identificador único do consumível.
/// @param {String} _name Nome exibido do consumível.
/// @param {String} _description Texto descritivo do consumível.
/// @param {Asset.GMSprite} _sprite Sprite do consumível.
/// @param {Real} _weight Peso do consumível.
/// @param {Bool} _is_corrupted Indica se o consumível afeta a sanidade.
/// @param {Real} _heal_value Quantidade de vida restaurada.
/// @param {String} _effect_description Descrição do efeito.
function Consumable(_id, _name, _description, _sprite, _weight, _is_corrupted, _heal_value, _effect_description) : Item(_id, _name, _description, _sprite, "Consumable", _weight, _is_corrupted) constructor {
    heal_value = _heal_value;
    effect_description = _effect_description;
}

/// @function init_item_definitions()
/// @descricao Inicializa o banco de dados global de itens com exemplos.
function init_item_definitions() {
    global.item_database = {};

    // Função auxiliar para adicionar itens ao banco
    var _add_item = function(_item) {
        global.item_database[$ _item.id] = _item;
    }

    // --- Define Items ---

    // Rusty Key
    _add_item(new Item(
        "rusty_key", 
        "Chave Enferrujada", 
        "Uma chave velha e corroída. O que ela abre?", 
        spr_missing, // Placeholder sprite
        "Key", 
        0.1, 
        false
    ));

    // Pistol
    _add_item(new Weapon(
        "pistol", 
        "Pistola Walther P38", 
        "Uma arma de serviço alemã confiável. 9mm.", 
        Spr_walther_p38, 
        1.5, 
        false, 
        20, 
        300,
        8 // ammo_capacity
    ));

    // Corrupted Doll
    _add_item(new Item(
        "corrupted_doll", 
        "Boneca Corrompida", 
        "Uma boneca de porcelana com olhos vazios. Segurá-la faz sua mente girar.", 
        spr_missing, // Placeholder sprite
        "Lore", 
        0.5, 
        true
    ));

    // Pistol Ammo (Cartridge)
    _add_item(new Item(
        "pistol_ammo",
        "Munição de Pistola",
        "Cartuchos 9mm para a Walther P38.",
        Spr_cartucho_walther_p38,
        "Ammo",
        0.05,
        false
    ));

    // Combat Knife
    _add_item(new Weapon(
        "combat_knife",
        "Faca de Combate",
        "Uma lâmina de aço carbono, surrada pelo uso mas perfeitamente afiada. Inscrições na base sugerem que pertenceu a um oficial de alta patente.",
        spr_missing, // Placeholder
        0.5,
        false,
        15,
        50,
        0
    ));

    // Herbal Medicine
    _add_item(new Consumable(
        "herbal_medicine",
        "Ervas Medicinais",
        "Uma mistura caseira de ervas esmagadas e álcool forte. O cheiro é horrível, mas estanca sangramentos e clareia a mente.",
        spr_missing, // Placeholder
        0.2,
        false,
        25,
        "Cura ferimentos leves."
    ));

    // Old Diary
    _add_item(new Item(
        "old_diary",
        "Diário Velho",
        "As páginas estão amareladas e quebradiças. A maioria do texto está ilegível devido à umidade, mas as datas finais mostram um declínio rápido na sanidade do autor.",
        spr_missing, // Placeholder
        "Lore",
        0.3,
        false
    ));

    // Torn Photo
    _add_item(new Item(
        "torn_photo",
        "Foto Rasgada",
        "Metade de uma fotografia em preto e branco. Mostra um grupo de soldados sorrindo em frente a um prédio que não existe mais. Alguém riscou os rostos com força.",
        spr_missing, // Placeholder
        "Lore",
        0.01,
        false
    ));

    // Basement Key
    _add_item(new Item(
        "basement_key",
        "Chave do Porão",
        "Uma chave pesada de ferro fundido. Está fria ao toque, inexplicavelmente mais fria que o ar ao redor.",
        spr_missing, // Placeholder
        "Key",
        0.1,
        false
    ));

    // Strange Amulet
    _add_item(new Item(
        "strange_amulet",
        "Amuleto Estranho",
        "Um pequeno pingente feito de um metal iridescente que parece vibrar levemente. Olhar para ele por muito tempo causa náuseas e visões periféricas.",
        spr_missing, // Placeholder
        "Artifact",
        0.2,
        true
    ));

    show_debug_message("Banco de itens inicializado.");
}
