/// @descricao: Aplica dano ao inimigo atingido pelo hitbox
if (other.id != owner) {
    if (variable_instance_exists(other, "TakeDamage")) {
        other.TakeDamage(damage);
    } else if (variable_instance_exists(other, "hp")) {
        // Fallback caso não exista método TakeDamage
        other.hp -= damage;
        if (other.hp <= 0) instance_destroy(other);
    }
    
    // Destrói o hitbox para evitar dano múltiplo em frames consecutivos
    instance_destroy();
}
