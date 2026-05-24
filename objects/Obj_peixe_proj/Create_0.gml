// peixe projetil inicialização
sprite_index = Spr_peixe_jogaveu_azul;
// reduzir tamanho permanentemente quando arremessado
image_xscale = 0.5;
image_yscale = 0.5;

// default velocities (can be overridden by creator)
if (!variable_local_exists("hspeed")) hspeed = 0;
if (!variable_local_exists("vspeed")) vspeed = 0;

gravity = 0.35; // gravity applied each step

damage = 5; // optional
