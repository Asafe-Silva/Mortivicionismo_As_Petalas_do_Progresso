if (para){
	
	image_alpha-=0.01
	if (image_alpha<=0) instance_destroy()
	exit;
	
}

image_angle += 8

x += lengthdir_x(vel,dir)
y += lengthdir_y(vel,dir)

if (point_distance(x,y,xstart,ystart) > dist){
	
	para = 1
	instance_destroy()
	
}

if (place_meeting(x,y,oPlayerMilitar)){
	
	para = 1
	
	with(oPlayerMilitar){
		
		TakeDamage(other.dano)
		
	}
}