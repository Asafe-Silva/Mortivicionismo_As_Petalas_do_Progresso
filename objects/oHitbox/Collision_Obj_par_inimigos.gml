/// @description Damage Enemy
if (other.id != owner) {
    if (variable_instance_exists(other, "TakeDamage")) {
        other.TakeDamage(damage);
    } else if (variable_instance_exists(other, "hp")) {
        // Fallback if no method
        other.hp -= damage;
        if (other.hp <= 0) instance_destroy(other);
    }
    
    // Destroy hitbox to prevent multi-frame damage
    instance_destroy();
}
