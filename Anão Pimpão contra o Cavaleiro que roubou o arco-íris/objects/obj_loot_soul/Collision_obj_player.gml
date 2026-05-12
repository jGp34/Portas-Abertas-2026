// Só coleta se já não estiver em processo de sumir
if (!coletado) {
    coletado = true; // Ativa o fade no Step
    
    // Adiciona ao recurso global
    global.souls += quantidade;
    
    show_debug_message("Coletou " + string(quantidade) + " souls! Total: " + string(global.souls));
    
    // Opcional: Tocar um s	om de coleta leve
     audio_play_sound(sfx_player_soul, 1, false);
}