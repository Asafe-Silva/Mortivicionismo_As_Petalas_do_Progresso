
// =========================
// PLAYER TARGET
// =========================

var player = instance_nearest(x, y, oPlayerMilitar);

var vx = 0;
var vy = 0;

if (player != noone)
{
    var dist = point_distance(x, y, player.x, player.y);

    if (dist < vision_range)
    {
        var dir = point_direction(x, y, player.x, player.y);

        x += lengthdir_x(1.5, dir);
        y += lengthdir_y(1.5, dir);

        vx = player.x - x;
        vy = player.y - y;
    }
}



// =========================
// SEPARAÇÃO (INIMIGOS)
// =========================

var _other = instance_place(x, y, Obj_par_inimigos);

if (_other != noone && _other != id)
{
    var dir2 = point_direction(_other.x, _other.y, x, y);

    x += lengthdir_x(1, dir2);
    y += lengthdir_y(1, dir2);
}



// =========================
// SEPARAÇÃO (PLAYER)
// =========================

var _player = instance_place(x, y, oPlayerMilitar);

if (_player != noone)
{
    var dir3 = point_direction(_player.x, _player.y, x, y);

    x += lengthdir_x(2, dir3);
    y += lengthdir_y(2, dir3);

    // dano opcional já existente no seu sistema pai
}



// =========================
// FLIP HORIZONTAL
// =========================

if (vx > 0)
    image_xscale = -1;
else if (vx < 0)
    image_xscale = 1;



// =========================
// SPRITE SYSTEM
// =========================

if (player != noone)
{
    var dx = player.x - x;
    var dy = player.y - y;

    var abs_dx = abs(dx);
    var abs_dy = abs(dy);

    // horizontal (corrida)
    if (abs_dx > abs_dy)
    {
        sprite_index = Spr_pescador_Antonio_corendo;
    }
    else
    {
        // vertical
        if (dy < 0)
        {
            if (abs_dx > 20)
                sprite_index = Spr_pescador_Antonio_cima_lateral;
            else
                sprite_index = Spr_pescador_Antonio_cima;
        }
        else
        {
            if (abs_dx > 20)
                sprite_index = Spr_pescador_Antonio_baixo_lateral;
            else
                sprite_index = Spr_pescador_Antonio_baixo;
        }
    }
}
else
{
    sprite_index = Spr_pescador_Antonio_parado;
}



// =========================
// DEBUG (OPCIONAL)
// =========================

// draw_self(); fica no Draw Event

