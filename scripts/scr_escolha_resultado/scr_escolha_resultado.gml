function scr_escolha_resultado(index) {

    pagina = 0;
    tem_escolha = false;

    ds_grid_destroy(texto_grid);
    texto_grid = ds_grid_create(4, 0);

    switch (npc_atual) {

        // ======================
        case "joao":

            switch (index) {

                case 0:
                    ds_grid_add_text(
                        "Ele parece sentir-se importante.",
                        -1, 0, ""
                    );
                break;

                case 1:
                    ds_grid_add_text(
                        "Talvez não seja tão simples assim, já que eu menti.",
                        Spr_Joao_Caseiro,
                        1,
                        "João"
                    );
                break;

                case 2:
                    ds_grid_add_text(
                        "Você está a ser ridícula!",
                        -1, 0, ""
                    );
                break;
            }

        break;

        // =========================
        case "Bolliver":

            switch (dialog_state) {

                // ===================
                // PRIMEIRA ESCOLHA
                case 0:

                    switch (index) {

                        case 0: // Aceitar iogurte
                            dialog_state = 1;

                            ds_grid_add_text("Ótimo! Toma aqui", Spr_Bolliver, 1, "Bolliver");
                            ds_grid_add_text("O que eu faço agora…?",-1, 0, "");

                            tem_escolha = true;
                            opcoes = [
                                "Jogar fora",
                                "Comer",
                                "Deixar cair sem querer"
                            ];
                        break;

                        case 1: // Grosso
                            ds_grid_add_text("Eita… grosseria gratuita.",Spr_Bolliver, 1, "Bolliver");
                        break;

                        case 2: // Perguntar sabor
                            dialog_state = 2;

                            ds_grid_add_text("É de cebola com morango.",Spr_Bolliver, 1, "Bolliver");
                            ds_grid_add_text("Isso explica muita coisa…",-1, 0, "");

                            tem_escolha = true;
                            opcoes = [
                                "Se afastar lentamente",
                                "Pegar e comer",
                                "Fingir que sumiu"
                            ];
                        break;
                    }

                break;

                // ===================
                // RAMIFICAÇÃO: ACEITOU IOGURTE
                case 1:

                    switch (index) {

                        case 0:
                            ds_grid_add_text("Você joga fora. Bolliver fica triste.",-1, 0, "");
                        break;

                        case 1:
                            ds_grid_add_text("Você come. Minutos depois, passa muito mal.",-1, 0, "");
                        break;

                        case 2:
                            ds_grid_add_text("O iogurte cai no chão. Bolliver não percebe.",-1, 0, "");
                        break;
                    }

                break;

                // ===================
                // RAMIFICAÇÃO: SABOR
                case 2:

                    switch (index) {

                        case 0:
                            ds_grid_add_text("Você se afasta lentamente. Bolliver não nota.",-1, 0, "");
                        break;

                        case 1:
                            ds_grid_add_text("Você come. Agora entende o erro.",-1, 0, "" );
                        break;

                        case 2:
                            ds_grid_add_text("Bolliver entra em desespero. Ele acredita.",-1, 0, "");
                        break;
                    }

                break;

            }
		
        break;
		
		case "Gatogril":
    }
}
