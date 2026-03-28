// Obj_Walther_P38 - Create
event_inherited(); // Inherit basic properties (itemId, pickupRange)

itemId = "pistol";
pickupRange = 25; // Slightly larger range for weapon

// Weapon specific logic
max_ammo = 6;
if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = max_ammo;
if (!variable_global_exists("walther_ammo")) global.walther_ammo = max_ammo;
if (!variable_global_exists("have_walther")) global.have_walther = false;

fire_rate = 12; // passos entre tiros
fire_cooldown = 0;
reloading = false;
reload_time = 60; // passos de recarga
reload_timer = 0;

// Override OnCollect
OnCollect = function() {
    global.have_walther = true;
    global.walther_ammo = global.walther_max_ammo;
    
    // Auto-equip when collected
    if (variable_global_exists("item_database")) {
        global.arma_equipada = global.item_database[$ itemId];
    }
    
    show_debug_message("Walther P38 unlock via OnCollect and Auto-equipped");
}
