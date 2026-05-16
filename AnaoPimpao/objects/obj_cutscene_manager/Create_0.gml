// --- obj_cutscene_manager -> Create ---
gui_width = 1280; // VOLTA PARA O PADRÃO SEGURO DO SEU JOGO
gui_height = 720;
display_set_gui_size(gui_width, gui_height);

fade_alpha = 1;      
fade_speed = 0.02;   
state = "fade_in";   

current_scene = 0;   
timer = 0;           

target_room = noone; 
scenes = [];

// --- DADOS DOS CRÉDITOS ---
show_credits = false;
credits_data = [];
credits_y = gui_height + 50;
credits_total_height = 0;

// --- SINCRONIZAÇÃO DE ÁUDIO ---
music_asset = noone;
music_id = noone;
credits_speed = 1.0; 
speed_calculated = false;

if (window_get_fullscreen()) {
    call_later(1, time_source_units_frames, function() {
        surface_resize(application_surface, display_get_width(), display_get_height());
    });
}