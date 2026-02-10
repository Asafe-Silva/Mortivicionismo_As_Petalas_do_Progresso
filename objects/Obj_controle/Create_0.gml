Scr_iniciar_item();

if (!instance_exists(Obj_GameState)) {
	// cria no mesmo layer/posição do controle
	instance_create(x, y, Obj_GameState);
}
