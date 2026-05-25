if (mostrar_pergunta)
{
    // Fundo escuro
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(250, 180, 710, 400, false);

    draw_set_alpha(1);

    // Texto
    draw_set_color(c_white);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(480, 240, "Quer continuar?");



    // =========================
    // BOTÃO SIM
    // =========================

    draw_set_color(c_green);

    draw_rectangle(sim_x1, sim_y1, sim_x2, sim_y2, false);

    draw_set_color(c_white);

    draw_text((sim_x1 + sim_x2) / 2, (sim_y1 + sim_y2) / 2, "SIM");



    // =========================
    // BOTÃO NÃO
    // =========================

    draw_set_color(c_red);

    draw_rectangle(nao_x1, nao_y1, nao_x2, nao_y2, false);

    draw_set_color(c_white);

    draw_text((nao_x1 + nao_x2) / 2, (nao_y1 + nao_y2) / 2, "NÃO");
}