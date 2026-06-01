// =========================
// PLAYER TARGET
// =========================

depth = -y

var player = alvo

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
		
		var dir = point_direction(x,y,player.x,player.y)
		
        move_x = lengthdir_x(move_speed,dir)//sign(player.x - x);
        move_y = lengthdir_y(move_speed,dir)//sign(player.y - y);
    }
}

//ataque

var dir = point_direction(x,y,player.x,player.y)
var dis = point_distance (x,y,player.x,player.y)

var _x = x + lengthdir_x(2,dir)
var _y = y + lengthdir_y(2,dir)

if (place_meeting(_x,_y,oPlayerMilitar)){
	
	joga_peixe_timer--
	
	if (!joga_peixe_timer){
	
		with(oPlayerMilitar){
		
			TakeDamage(other.ataque_dano)
		
		}
		
		ataque_timer = ataque_tempo
		
	}
}

if (fish_count){
	
	alvo = instance_nearest(x,y,oPlayerMilitar)
	
	if (dis<joga_peixe_dist){
	
		move_x = 0
		move_y = 0
	
		joga_peixe_timer--
	
		if (!joga_peixe_timer){
	
			var pei = instance_create_depth(x,y,depth,Obj_peixe_arremessavel)
			pei.dir = point_direction(x,y,player.x,player.y)
	
			joga_peixe_timer = joga_peixe_tempo
			fish_count--
		
		}	
	}	
}else{
	
	if(joga_peixe_timer = joga_peixe_tempo){
		
		randomise()
		chance = irandom_range(1,100)
		
	}
	
	//pegando mais peixes
	if (chance = clamp(chance,0,55)){
		
		alvo = instance_nearest(x,y,Obj_CaixaPeixe)
		
		dis = point_distance(x,y,alvo.x,alvo.y)
		
		if (dis<32){
			
			caixa_timer--
			move_x = 0
			move_y = 0
			move_speed = 0
			
			if (!caixa_timer){
				
				fish_count = 3
				caixa_timer = caixa_tempo
				move_speed = 1.5
				alvo = instance_nearest(x,y,oPlayerMilitar)
		
			}
		}
	}
	
	//ficando parado
	if (chance = clamp(chance,55,65)){
		
		move_x = 0
		move_y = 0
		move_speed = 0
		
	}
	
	//indo atras do player
	if (chance = clamp(chance,65,100)){
	
		alvo = instance_nearest(x,y,oPlayerMilitar)
		
	}
	
	joga_peixe_timer--
	
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

if (sign(move_x) != 0)image_xscale = sign(-move_x)

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
