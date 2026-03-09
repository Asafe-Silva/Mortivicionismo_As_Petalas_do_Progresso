// This would be the sprite, but since we are code-only, we assume the user assigns one or we use a placeholder draw event.
draw_self();
draw_healthbar(x-10, y-20, x+10, y-15, (hp/max_hp)*100, c_black, c_red, c_green, 0, true, true);
