function scr_item_remove(index) {
    var item = global.inv[| index];
    global.inv_peso_atual -= item.peso;
    ds_list_delete(global.inv, index);
}
