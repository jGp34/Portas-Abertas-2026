// Pega a vida máxima (que já está salva no global e atualizada pela loja)
// e preenche a vida atual do jogador para ele começar a fase com a barra cheia:
global.player_hp = global.max_hp;

// Toca a música
if (!audio_is_playing(msc_game)) {
    audio_play_sound(msc_game, 1, true);
}