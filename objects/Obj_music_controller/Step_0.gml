// =========================
// MENU
// =========================

if room == rm_TitleScreen
{
    if musica_atual != Som_menu_creditos
    {
        audio_stop_all();

        audio_play_sound(Som_menu_creditos, 1, true);

        musica_atual = Som_menu_creditos;
    }
}



// =========================
// GAMEPLAY NORMAL
// =========================

if room == Roo_porto
{
    if musica_atual != Som_luta_inicial
    {
        audio_stop_all();

        audio_play_sound(Som_luta_inicial, 1, true);

        musica_atual = Som_luta_inicial;
    }
}



// =========================
// BOSS
// =========================

if room == Roo_fase_boss
{
    if musica_atual != Som_boss_forma_1
    {
        audio_stop_all();

        audio_play_sound(Som_boss_forma_1, 1, true);

        musica_atual = Som_boss_forma_1;
    }
}



// =========================
// SEGUNDA FASE DO BOSS
// =========================

if instance_exists(Roo_fase_boss)
{
    if Obj_pescador_boss.hp <= 100 && boss_fase2 == false
    {
        audio_stop_all();

        audio_play_sound(Som_boss_forma_2, 1, true);

        musica_atual = Som_boss_forma_2;

        boss_fase2 = true;
    }
}



// =========================
// MORTE DO BOSS
// =========================

if !instance_exists(Obj_pescador_boss)
{
    if room == Roo_fase_boss && boss_morreu == false
    {
        boss_morreu = true;

        audio_stop_all();

        alarm[0] = room_speed * 2;
    }
}
