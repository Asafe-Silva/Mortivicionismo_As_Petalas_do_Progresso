/// scr_textos(npc_name)
function scr_textos(npc_name) {

	 // LIMPA O GRID CORRETAMENTE
    ds_grid_destroy(texto_grid);
	texto_grid = ds_grid_create(4, 0);

	
    tem_escolha = false;

    switch (npc_name) {

        case "Gatogirl":
		    ds_grid_add_text("Eu amo meu namorado.", Spr_gatoman_falando, 1, "Gatogirl");
		    ds_grid_add_text("De hoje para sempre.", Spr_gatoman_falando, 1, "Gatogirl");
		    ds_grid_add_text("Amém!", Spr_gatoman_falando, 1, "Gatogirl");

		    // pensamento
		    ds_grid_add_text("Ela está rezando...?", -1, 0, "");

		    tem_escolha = false;
		break;
		
		case "joao":
		    ds_grid_add_text("Eu odeio ateus.", Spr_Joao_Caseiro, 1, "João");

		    tem_escolha = true;
		    opcoes = [
		        "Ignorar",
		        "Responder com calma",
		        "Ofender de volta"
		    ];
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