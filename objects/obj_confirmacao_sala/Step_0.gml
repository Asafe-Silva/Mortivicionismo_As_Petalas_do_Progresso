// Detecta player entrando na área
if (place_meeting(x, y, oPlayerMilitar))
{
    mostrar_pergunta = true;
}



// =========================
// CLIQUE NO BOTÃO SIM
// =========================

if (mostrar_pergunta)
{
    if (mouse_check_button_pressed(mb_left))
    {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);

        // BOTÃO SIM
        if (mx >= sim_x1 && mx <= sim_x2)
        {
            if (my >= sim_y1 && my <= sim_y2)
            {

                // ROOM DE TESTE
                if (room == local_de_teste)
                {
                    room_goto(Roo_porto);
                }

                // ROOM PORTO
                else if (room == Roo_porto)
                {
                    room_goto(Roo_fase_boss);
                }

            }
        }

        // BOTÃO NÃO
        if (mx >= nao_x1 && mx <= nao_x2)
        {
            if (my >= nao_y1 && my <= nao_y2)
            {
                mostrar_pergunta = false;
            }
        }
    }
}