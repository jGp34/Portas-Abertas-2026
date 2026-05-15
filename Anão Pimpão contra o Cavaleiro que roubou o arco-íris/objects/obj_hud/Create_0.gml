// obj_hud -> Evento Create

// Defina aqui a resolução "base" do seu jogo. 
// Exemplo: 1280x720, 1920x1080, ou 640x360 se for pixel art puro.
var _resolucao_base_x = 1280; 
var _resolucao_base_y = 720;  

// Isso obriga os textos a sempre manterem a proporção e qualidade original,
// independente do tamanho da janela ou do monitor!
display_set_gui_size(_resolucao_base_x, _resolucao_base_y);

// Força a atualização da superfície caso o jogo já inicie em tela cheia
if (window_get_fullscreen()) {
    // Dá o atraso de 1 frame para garantir que a janela já assumiu o tamanho do monitor
    call_later(1, time_source_units_frames, function() {
        surface_resize(application_surface, display_get_width(), display_get_height());
    });
}




