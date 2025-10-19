/// scr_textos(npc_name)
function scr_textos(npc_name) {

    switch (npc_name) {
        case "Gatogirl":
			ds_grid_add_text("Eu amo meu namorado", Spr_gatoman_falando, 1, "Gatogril");
			ds_grid_add_text("De hoje para sempre", Spr_gatoman_falando, 1, "Gatogril");
			ds_grid_add_text("Amen!", Spr_gatoman_falando, 1, "Gatogril");
			ds_grid_add_text("'Eu acho que esta gata esta orando para o Dev'", Spr_prota_falando, 0, "Livia Mordvik");	
		break;

		case "joao":
            ds_grid_add_text("Eu Odeio Ateus", Spr_gatoman_falando, 1, "João");
            array_push(t, "Que deus destrua, todos os hereges, mundanos");
            array_push(t, "Amen!");
            break;
			
			
        default:
            array_push(t, "…");
            break;
    }

    
}

function ds_grid_add_row(){
	///@arg ds_grid
	
	var _grid = argument[0];
	ds_grid_resize(_grid, ds_grid_width(_grid), ds_grid_height(_grid) + 1);
	return(ds_grid_height(_grid) - 1);
}

function ds_grid_add_text(){
	///@arg texto
	///@arg retrato
	///@arg lado
	
	var _grid = texto_grid;
	var _y = ds_grid_add_row(_grid);
	
	_grid[# 0, _y] = argument[0];
	_grid[# 1, _y] = argument[1];
	_grid[# 2, _y] = argument[2];
	_grid[# 3, _y] = argument[3];
}