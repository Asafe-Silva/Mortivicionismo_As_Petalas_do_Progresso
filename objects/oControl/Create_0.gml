if (!instance_exists(Obj_GameState)) {
	// cria no mesmo layer/posição do controle
	instance_create(x, y, Obj_GameState);
}

if (!instance_exists(Obj_InventoryManager)) {
    instance_create_depth(0, 0, 0, Obj_InventoryManager);
}
init_item_definitions();