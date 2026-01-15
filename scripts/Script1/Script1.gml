/// scr_textos(npc_name)
function scr_textos(npc_name) {
	
	npc_atual = npc_name;
	var estado = scr_get_npc_estado(npc_name);
	
	 // LIMPA O GRID CORRETAMENTE
    ds_grid_destroy(texto_grid);
	texto_grid = ds_grid_create(4, 0);
	
    tem_escolha = false;

    switch (npc_name) {

        case "Gatogirl":
			switch (estado) {

		        case 0:
		            ds_grid_add_text("Eu amo meu namorado.", Spr_gatoman_falando, 1, "Gatogirl");
		            ds_grid_add_text("De hoje para sempre.", Spr_gatoman_falando, 1, "Gatogirl");
		            ds_grid_add_text("Amém!", Spr_gatoman_falando, 1, "Gatogirl");
		            ds_grid_add_text("Ela está rezando...?", -1, 0, "");
		            scr_inc_npc_estado("Gatogirl");
		        break;

		        case 1:
		            ds_grid_add_text("Ela continua rezando.", -1, 0, "");
		            ds_grid_add_text("Já é a segunda vez que vejo isso.", -1, 0, "");
		            scr_inc_npc_estado("Gatogirl");
		        break;

		        case 2:
		            ds_grid_add_text("Sempre a mesma oração...", -1, 0, "");
		            ds_grid_add_text("Por que ela faz isso?", -1, 0, "");
		            scr_inc_npc_estado("Gatogirl");
		        break;

		        default:
		            ds_grid_add_text("Eu a devo questionar?", -1, 0, "");

		            tem_escolha = true;
		            opcoes = [
		                "Sim.",
		                "Prefiro não incomodar."
		            ];
		        break;
			}
		break;
		
		case "joao":
		dialog_state = 0;
		    ds_grid_add_text("Sou o teu novo chefe, mulher.", Spr_Joao_Caseiro, 1, "João");
			ds_grid_add_text("E iria dar-te ouvidos, porquê?", Spr_prota_falando, 1, "Livia M.");
			ds_grid_add_text("Porque imponho respeito em todos os lugares por onde passo!", Spr_Joao_Caseiro, 1, "João");
		    
			// pensamento
		    ds_grid_add_text("Duvido bastante, tenho quase a certeza de que nunca o vi antes.", -1, 0, "");
		    
			// existe escolha
			tem_escolha = true;
			
			opcoes = [
				"Se o senhor o diz.",
				"Irei confirmar com o general.",
				"Das interessiert mich nicht die Bohne!"
			];

		break;
		
		case "Bolliver":
		dialog_state = 0;
		
		    ds_grid_add_text("uma Bola ...?",  -1, 0, "r");
			ds_grid_add_text("oi?", Spr_prota_falando, 1, "Livia M.");
			ds_grid_add_text("cê que yorgute?", Spr_Bolliver, 1, "Bolliver");
		    
			// pensamento
		    ds_grid_add_text("Eu deveria aceitar...?", -1, 0, "");
		    
			// existe escolha
			tem_escolha = true;
			
			opcoes = [
				"Sim, não tenho nada a perder",
				"não, voce é estranho :P",
				"Qual o sabor?"
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