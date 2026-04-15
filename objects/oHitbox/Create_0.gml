/// @description Initialize Hitbox
damage = 10;
owner = noone;
life_time = 5; // Frames
alarm[0] = life_time;

// List to track entities already hit (if piercing)
// For now, simpler: destroy on first contact.
