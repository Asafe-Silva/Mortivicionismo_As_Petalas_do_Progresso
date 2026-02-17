if (!instance_exists(oInventoryManager)) {
    instance_create_depth(0, 0, 0, oInventoryManager);
}

if (!instance_exists(oInventoryUI)) {
    instance_create_depth(0, 0, -100, oInventoryUI);
}
init_item_definitions();