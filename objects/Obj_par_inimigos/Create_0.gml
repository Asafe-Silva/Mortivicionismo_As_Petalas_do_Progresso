/// @descrição inicializar pai inimigo
hp = 100;
max_hp = 100;

/// @função receber dano(_amount)
TakeDamage = function(_amount) {
    hp -= _amount;
    show_debug_message("Enemy took " + string(_amount) + " damage. HP: " + string(hp));
    
    if (hp <= 0) {
        instance_destroy();
    }
}
