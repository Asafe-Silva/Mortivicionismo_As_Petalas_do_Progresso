if inicializar == false{
	scr_textos();
	inicializar = true;	
}

if mouse_check_button(mb_left){
	if pagina < array_length_id(texto) - 1{
		pagina++;
	}else{
		instance_destroy();
	}
}