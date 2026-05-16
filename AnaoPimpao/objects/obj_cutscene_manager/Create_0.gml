// --- obj_cutscene_manager -> Create ---
gui_width = 1280;
gui_height = 720;
display_set_gui_size(gui_width, gui_height);

fade_alpha = 1;      
fade_speed = 0.02;   
state = "fade_in";   

current_scene = 0;   
timer = 0;           

target_room = noone; 
scenes = [];

// ---> NOVO: Variáveis para os Créditos <---
show_credits = false;    // Fica falso por padrão (A Intro não usa)
credits_text = "";       // Texto que será desenhado
credits_y = gui_height;  // Começa fora da tela (embaixo)

// ---> NOVO: Sincronização de Áudio <---
music_asset = noone;         // Arquivo da música
music_id = noone;            // ID exato do som tocando
credits_speed = 1.5;         // Velocidade de segurança (fallback)
speed_calculated = false;    // Trava do cálculo

if (window_get_fullscreen()) {
    call_later(1, time_source_units_frames, function() {
        surface_resize(application_surface, display_get_width(), display_get_height());
    });
}