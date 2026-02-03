// Obj_Walther_P38 - Create
pickup_range = 18;
max_ammo = 6;
if (!variable_global_exists("walther_max_ammo")) global.walther_max_ammo = max_ammo;
if (!variable_global_exists("walther_ammo")) global.walther_ammo = max_ammo;
if (!variable_global_exists("have_walther")) global.have_walther = false;
fire_rate = 12; // passos entre tiros
fire_cooldown = 0;
reloading = false;
reload_time = 60; // passos de recarga
reload_timer = 0;
