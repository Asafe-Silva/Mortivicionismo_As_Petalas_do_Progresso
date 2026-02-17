
/// @function Item(_id, _name, _description, _sprite, _type, _weight, _is_corrupted)
/// @description Base constructor for all items.
/// @param {String} _id Unique identifier for the item.
/// @param {String} _name Display name of the item.
/// @param {String} _description Flavour text for the item.
/// @param {Asset.GMSprite} _sprite Sprite asset for the item.
/// @param {String} _type Item type (e.g., "Weapon", "Consumable", "Key").
/// @param {Real} _weight Weight of the item.
/// @param {Bool} _is_corrupted Whether the item affects sanity.
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

/// @function Weapon(_id, _name, _description, _sprite, _weight, _is_corrupted, _damage, _range)
/// @description Constructor for weapon items, inheriting from Item.
/// @param {String} _id Unique identifier for the weapon.
/// @param {String} _name Display name of the weapon.
/// @param {String} _description Flavour text for the weapon.
/// @param {Asset.GMSprite} _sprite Sprite asset for the weapon.
/// @param {Real} _weight Weight of the weapon.
/// @param {Bool} _is_corrupted Whether the weapon affects sanity.
/// @param {Real} _damage Damage dealt by the weapon.
/// @param {Real} _range Effective range of the weapon.
function Weapon(_id, _name, _description, _sprite, _weight, _is_corrupted, _damage, _range) : Item(_id, _name, _description, _sprite, "Weapon", _weight, _is_corrupted) constructor {
    damage = _damage;
    range = _range;
}

/// @function Consumable(_id, _name, _description, _sprite, _weight, _is_corrupted, _heal_value, _effect_description)
/// @description Constructor for consumable items, inheriting from Item.
/// @param {String} _id Unique identifier for the consumable.
/// @param {String} _name Display name of the consumable.
/// @param {String} _description Flavour text for the consumable.
/// @param {Asset.GMSprite} _sprite Sprite asset for the consumable.
/// @param {Real} _weight Weight of the consumable.
/// @param {Bool} _is_corrupted Whether the consumable affects sanity.
/// @param {Real} _heal_value Amount of health restored.
/// @param {String} _effect_description specific effect.
function Consumable(_id, _name, _description, _sprite, _weight, _is_corrupted, _heal_value, _effect_description) : Item(_id, _name, _description, _sprite, "Consumable", _weight, _is_corrupted) constructor {
    heal_value = _heal_value;
    effect_description = _effect_description;
}

/// @function init_item_definitions()
/// @description Initializes the global item database with example items.
function init_item_definitions() {
    global.item_database = {};

    // Helper function to add items to the database
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
        300
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

    show_debug_message("Item Database Initialized.");
}
