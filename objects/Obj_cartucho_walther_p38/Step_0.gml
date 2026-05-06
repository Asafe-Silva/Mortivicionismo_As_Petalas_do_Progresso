// Step: movimenta cartucho e permite pickup automático ao se aproximar do jogador
vspeed += 0.1; // leve gravidade
life -= 1;
if (life <= 0) instance_destroy();

var p = instance_nearest(x, y, oPlayerMilitar);
if (instance_exists(p) && point_distance(x, y, p.x, p.y) <= 25) {
    // Add to inventory
    var _invManager = instance_find(oInventoryManager, 0);
    if (_invManager != noone) {
        var _item = global.item_database[$ "pistol_ammo"];
        if (_item != undefined) {
             if (_invManager.InventoryAdd(_item)) {
                 instance_destroy();
             }
        }
    }
}
