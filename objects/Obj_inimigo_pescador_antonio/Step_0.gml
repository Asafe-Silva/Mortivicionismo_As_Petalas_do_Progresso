// Comportamento avançado do pescador inimigo

var player = instance_nearest(x, y, oPlayerMilitar);

// movement intent
var move_x = 0;
var move_y = 0;

// cooldowns
if (pick_cooldown > 0) pick_cooldown -= 1;
if (throw_cooldown > 0) throw_cooldown -= 1;
if (decision_timer > 0) decision_timer -= 1;

// (last_dir_x/last_dir_y atualizam no final do passo baseado no movimento atual)

// função auxiliar: ângulo entre facing e jogador
function _vision_multiplier(_player) {
    if (_player == noone) return 0;
    var ang_to_player = point_direction(x, y, _player.x, _player.y);
    var facing_ang = point_direction(0, 0, last_dir_x, last_dir_y);
    var da = abs(ang_to_player - facing_ang);
    if (da > 180) da = 360 - da;
    if (da <= 45) return 0.9; // frente: um pouco menos que a visão atual
    if (da <= 135) return 0.5; // lado: metade
    return 0.25; // trás: 1/4
}

// Decisões quando sem peixes
if (fish_count <= 0) {
    if (action_state == "none") {
        // escolher ação com pesos (normalizando se necessário)
        var total = chance_pick + chance_stay + chance_flee + chance_approach;
        var r = irandom(total - 1);
        if (r < chance_pick) {
            // ir pegar peixe
            var _box = instance_nearest(x, y, Obj_CaixaPeixe);
            if (_box != noone) {
                action_state = "go_pick";
                action_target_x = _box.x;
                action_target_y = _box.y;
                // guarda local para voltar
                action_home_x = home_x;
                action_home_y = home_y;
            } else {
                // sem caixa, fallback para ficar parado
                action_state = "stay";
                decision_timer = 120;
            }
        } else if (r < chance_pick + chance_stay) {
            action_state = "stay";
            decision_timer = 120; // 2 segundos
        } else if (r < chance_pick + chance_stay + chance_approach) {
            // aproximar e tentar tocar o jogador
            action_state = "approach";
            decision_timer = 120;
        } else {
            // fugir para posição aleatória
            action_state = "flee";
            var _ang = irandom(359);
            var _dist = irandom_range(64, 160);
            action_target_x = x + lengthdir_x(_dist, _ang);
            action_target_y = y + lengthdir_y(_dist, _ang);
            decision_timer = 120;
        }
    }

    // executar ação
    if (action_state == "go_pick") {
        // mover até a caixa alvo
        var _dir = point_direction(x, y, action_target_x, action_target_y);
        move_x = lengthdir_x(move_speed, _dir);
        move_y = lengthdir_y(move_speed, _dir);
        // colisão simples
        if (!place_meeting(x + move_x, y, Obj_colisor)) x += move_x;
        if (!place_meeting(x, y + move_y, Obj_colisor)) y += move_y;
        if (point_distance(x, y, action_target_x, action_target_y) <= 12) {
            // tentar pegar
            if (pick_cooldown <= 0) {
                fish_count = min(fish_capacity, fish_count + 1);
                pick_cooldown = 30;
            }
            // volta para home
            action_state = "return_home";
            action_target_x = home_x; action_target_y = home_y;
        }
    } else if (action_state == "return_home") {
        var _dir2 = point_direction(x, y, action_target_x, action_target_y);
        move_x = lengthdir_x(move_speed, _dir2);
        move_y = lengthdir_y(move_speed, _dir2);
        if (!place_meeting(x + move_x, y, Obj_colisor)) x += move_x;
        if (!place_meeting(x, y + move_y, Obj_colisor)) y += move_y;
        if (point_distance(x, y, action_target_x, action_target_y) <= 8) {
            action_state = "none";
        }
    } else if (action_state == "stay") {
        // fica parado até o timer acabar
        move_x = 0; move_y = 0;
        if (decision_timer <= 0) action_state = "none";
    } else if (action_state == "flee") {
        var _dir3 = point_direction(x, y, action_target_x, action_target_y);
        move_x = lengthdir_x(move_speed * 1.2, _dir3);
        move_y = lengthdir_y(move_speed * 1.2, _dir3);
        if (!place_meeting(x + move_x, y, Obj_colisor)) x += move_x;
        if (!place_meeting(x, y + move_y, Obj_colisor)) y += move_y;
        if (decision_timer <= 0) action_state = "none";
    }

    else if (action_state == "approach") {
        // aproxima diretamente do jogador e causa dano ao tocar
        if (player != noone) {
            var _dirp = point_direction(x, y, player.x, player.y);
            move_x = lengthdir_x(move_speed * 1.4, _dirp);
            move_y = lengthdir_y(move_speed * 1.4, _dirp);
            if (!place_meeting(x + move_x, y, Obj_colisor)) x += move_x;
            if (!place_meeting(x, y + move_y, Obj_colisor)) y += move_y;

            // checar toque
            if (place_meeting(x, y, oPlayerMilitar)) {
                var _pl = instance_place(x, y, oPlayerMilitar);
                if (_pl != noone) {
                    if (variable_instance_exists(_pl, "TakeDamage")) {
                        _pl.TakeDamage(15);
                    } else if (variable_global_exists("player_hp")) {
                        global.player_hp = max(0, global.player_hp - 15);
                    }
                }
                // após atacar, espera um pouco
                decision_timer = 60;
                action_state = "none";
            }
        } else {
            action_state = "none";
        }
    }

} else {
    // comportamente com peixes: persegue/ajusta distância e ataca
    if (player != noone) {
        // visão direcional
        var vm = _vision_multiplier(player);
        var effective_vision = vision_range * vm;
        var distp = point_distance(x, y, player.x, player.y);
        if (distp <= effective_vision) {
            // definir desired_dist_current aleatória ao começar a perseguir
            if (desired_dist_current < 0) desired_dist_current = irandom_range(min_dist, max_dist);

            if (distp < min_dist) {
                var dir_away = point_direction(player.x, player.y, x, y);
                move_x = lengthdir_x(move_speed, dir_away);
                move_y = lengthdir_y(move_speed, dir_away);
            } else if (distp > desired_dist_current) {
                var dir_to = point_direction(x, y, player.x, player.y);
                move_x = lengthdir_x(move_speed, dir_to);
                move_y = lengthdir_y(move_speed, dir_to);
            } else {
                move_x = 0; move_y = 0;
            }

            // tentar arremessar se no alcance
            if (distp <= attack_range && throw_cooldown <= 0 && fish_count > 0) {
                // escolher sprite de ataque conforme frente/tras
                var ang_to_player = point_direction(x, y, player.x, player.y);
                var facing_ang = point_direction(0, 0, last_dir_x, last_dir_y);
                var da = abs(ang_to_player - facing_ang);
                if (da > 180) da = 360 - da;
                if (da <= 90) {
                    sprite_index = Spr_pescador_Antonio_ataque_frente;
                } else {
                    sprite_index = Spr_pescador_Antonio_ataque_tras;
                }

                var _dirt = ang_to_player;
                var _spd = 6 + irandom(2);
                var _proj = instance_create_layer(x, y - 8, "Instances", Obj_peixe_arremessavel);
                with (_proj) {
                    hspeed = lengthdir_x(_spd, _dirt);
                    vspeed = lengthdir_y(_spd, _dirt) - 4;
                    damage = 10;
                    owner = other.id;
                }
                fish_count -= 1;
                throw_cooldown = 60 + irandom(30);
                // reset desired_dist_current para próxima vez
                desired_dist_current = irandom_range(min_dist, max_dist);
            }
        } else {
            // não vê o jogador: limpa desired_dist_current
            if (desired_dist_current >= 0) {
                desired_dist_current = -1;
            }
        }
    }
}

// aplicar movimento com colisão padrão (aplica-se a todos os modos)
// horizontal
if (place_meeting(x + move_x * move_speed, y, Obj_colisor)
|| place_meeting(x + move_x * move_speed, y, oPlayerMilitar)
|| place_meeting(x + move_x * move_speed, y, Obj_par_inimigos))
{
    while (!place_meeting(x + sign(move_x), y, Obj_colisor)
    && !place_meeting(x + sign(move_x), y, oPlayerMilitar)
    && !place_meeting(x + sign(move_x), y, Obj_par_inimigos))
    {
        x += sign(move_x);
    }

    move_x = 0;
}

x += move_x * move_speed;

// vertical
if (place_meeting(x, y + move_y * move_speed, Obj_colisor)
|| place_meeting(x, y + move_y * move_speed, oPlayerMilitar)
|| place_meeting(x, y + move_y * move_speed, Obj_par_inimigos))
{
    while (!place_meeting(x, y + sign(move_y), Obj_colisor)
    && !place_meeting(x, y + sign(move_y), oPlayerMilitar)
    && !place_meeting(x, y + sign(move_y), Obj_par_inimigos))
    {
        y += sign(move_y);
    }

    move_y = 0;
}

y += move_y * move_speed;

// flip
if (move_x > 0) image_xscale = -1;
if (move_x < 0) image_xscale = 1;

// atualizar direção visual para o próximo frame
if (abs(move_x) > 0.001 || abs(move_y) > 0.001) {
    last_dir_x = sign(move_x);
    last_dir_y = sign(move_y);
}

// sprites de idle/andar
if (action_state == "none" && (abs(move_x) < 0.001 && abs(move_y) < 0.001)) {
    // parado: escolher entre parado normal ou cima dependendo do último movimento vertical
    if (last_dir_y < 0) sprite_index = Spr_pescador_Antonio_parado_cima;
    else sprite_index = Spr_pescador_Antonio_parado;
} else if (abs(move_x) > abs(move_y)) {
    sprite_index = Spr_pescador_Antonio_corendo;
} else {
    if (move_y < 0) {
        if (move_x != 0) sprite_index = Spr_pescador_Antonio_cima_lateral;
        else sprite_index = Spr_pescador_Antonio_cima;
    } else if (move_y > 0) {
        if (move_x != 0) sprite_index = Spr_pescador_Antonio_baixo_lateral;
        else sprite_index = Spr_pescador_Antonio_baixo;
    }
}

// destruir se sem vida
if (variable_instance_exists(id, "hp") && hp <= 0) {
    instance_destroy();
}

