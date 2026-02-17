if (!instance_exists(oInventoryManager)) {
    instance_create_depth(0, 0, 0, oInventoryManager);
}
init_item_definitions();