// Scr_iniciar_item(); // Comentado pois o script não existe e causaria crash
init_item_definitions();

if (!instance_exists(Obj_GameState)) {
	// cria no mesmo layer/posição do controle
	instance_create(x, y, Obj_GameState);
}
