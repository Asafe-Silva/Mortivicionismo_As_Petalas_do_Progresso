/// @description Initialize Enemy Parent
hp = 100;
max_hp = 100;

/// @function TakeDamage(_amount)
TakeDamage = function(_amount) {
    hp -= _amount;
    show_debug_message("Enemy took " + string(_amount) + " damage. HP: " + string(hp));
    
    if (hp <= 0) {
        instance_destroy();
    }
}
