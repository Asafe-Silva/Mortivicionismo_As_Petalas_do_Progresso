function scr_trauma_check_gatilhos(){

	// Percorre traumas para possíveis checagens futuras.
	// Atualmente nenhum gatilho padrão é chamado aqui; função existe para extensão.
	if (!ds_map_exists(global, "traumas")) exit;
	var keys = ds_map_keys(global.traumas);
	for (var i = 0; i < array_length(keys); i++) {
		var t = global.traumas[? keys[i]];
		// placeholder: se t tiver lógica própria, pode ser processada aqui
		// ex: verificar timers, desativar trauma, etc.
		if (!t.ativo) continue;
	}
}