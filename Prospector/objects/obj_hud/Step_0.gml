// =======================================================
// TELA CHEIA (FULLSCREEN)
// =======================================================
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    
    // Inverte a tela (Se estava fullscreen, vai pra janela. E vice-versa)
    window_set_fullscreen(!_is_fullscreen);

    // DICA DE OURO: Dá um atraso de 1 frame para dar tempo do Windows 
    // redimensionar a tela, e então ajustamos a qualidade gráfica do jogo
    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) {
            // Ajusta a superfície do jogo para o tamanho do monitor
            surface_resize(application_surface, display_get_width(), display_get_height());
        } else {
            // Ajusta a superfície do jogo para o tamanho da janela
            surface_resize(application_surface, window_get_width(), window_get_height());
        }
    });
}