// Herdar variáveis
event_inherited();

image_xscale = 1;

hp = 70;
max_hp = 70;

move_speed = 1.5;

// Peixe / combate
// começa com 3 peixes
fish_count = 3;
pick_cooldown = 0;
throw_cooldown = 0;

// limite de peixes que um inimigo carrega (inimigos pegam menos que jogador)
fish_capacity = 3;

// comportamento/decisão
decision_timer = 0; // contador para ações como fugir/esperar
action_state = "none"; // "none", "go_pick", "stay", "flee", "return_home"
action_target_x = x;
action_target_y = y;
home_x = x; home_y = y; // local padrão para voltar após pegar peixes
last_dir_x = 0; last_dir_y = 1; // direção visual/face padrão (baixo)
// desired distance current inicial (valor negativo indica 'não definido')
desired_dist_current = -1;

// parâmetros de comportamento
// visão base reduzida (será multiplicada por direção relativa)
vision_range = 160;
attack_range = 220;

// distância desejada para manter (valores base)
min_dist = 80;
desired_dist = 120;
max_dist = 160;

// chance (valores raw — normalizados internamente)
chance_pick = 65;
chance_stay = 10;
chance_flee = 20; // ajustado para 20%
chance_approach = 15; // 15% de tentar aproximar e tocar o jogador