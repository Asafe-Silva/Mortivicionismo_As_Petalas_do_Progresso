// =========================
// PLAYER TARGET
// =========================

var player = instance_nearest(x, y, oPlayerMilitar);

var move_x = 0;
var move_y = 0;

if (player != noone)
{
    var dist = point_distance(x, y, player.x, player.y);

    if (dist < vision_range)
    {
        var dir = point_direction(x, y, player.x, player.y);

        move_x = lengthdir_x(1.5, dir);
        move_y = lengthdir_y(1.5, dir);
    }
}



// =========================
// IA
// =========================

if (player != noone)
{
    var dist = point_distance(x, y, player.x, player.y);

    if (dist < vision_range)
    {
        move_x = sign(player.x - x);
        move_y = sign(player.y - y);
    }
}



// =========================
// COLISÃO HORIZONTAL
// =========================

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



// =========================
// COLISÃO VERTICAL
// =========================

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



// =========================
// FLIP
// =========================

if (move_x > 0)
{
    image_xscale = -1;
}

if (move_x < 0)
{
    image_xscale = 1;
}



// =========================
// SPRITES
// =========================

if (move_x == 0 && move_y == 0)
{
    sprite_index = Spr_pescador_Antonio_parado;
}
else
{
    // horizontal
    if (abs(move_x) > abs(move_y))
    {
        sprite_index = Spr_pescador_Antonio_corendo;
    }
    else
    {
        // cima
        if (move_y < 0)
        {
            if (move_x != 0)
            {
                sprite_index = Spr_pescador_Antonio_cima_lateral;
            }
            else
            {
                sprite_index = Spr_pescador_Antonio_cima;
            }
        }

        // baixo
        if (move_y > 0)
        {
            if (move_x != 0)
            {
                sprite_index = Spr_pescador_Antonio_baixo_lateral;
            }
            else
            {
                sprite_index = Spr_pescador_Antonio_baixo;
            }
        }
    }
}

