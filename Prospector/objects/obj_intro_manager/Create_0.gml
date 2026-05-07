// --- obj_intro_manager -> Create ---

gui_width = 1280;
gui_height = 720;
display_set_gui_size(gui_width, gui_height);

fade_alpha = 1;      
fade_speed = 0.02;   
state = "fade_in";   

current_scene = 0;   
timer = 0;           
target_room = rm_game; 

// LISTA DE CENAS (Suas 15 cenas)
scenes = [
    { spr: spr_intro_1,  dur: 180 },
    { spr: spr_intro_2,  dur: 180 },
    { spr: spr_intro_3,  dur: 180 },
    { spr: spr_intro_4,  dur: 180 },
    { spr: spr_intro_5,  dur: 180 },
    { spr: spr_intro_6,  dur: 180 },
    { spr: spr_intro_7,  dur: 180 },
    { spr: spr_intro_8,  dur: 180 },
    { spr: spr_intro_9,  dur: 180 },
    { spr: spr_intro_10, dur: 180 },
    { spr: spr_intro_11, dur: 180 },
    { spr: spr_intro_12, dur: 180 },
    { spr: spr_intro_13, dur: 180 },
    { spr: spr_intro_14, dur: 180 },
    { spr: spr_intro_15, dur: 180 }
];

// --- NOVIDADE: Garante qualidade se começar em Fullscreen ---
if (window_get_fullscreen()) {
    call_later(1, time_source_units_frames, function() {
        surface_resize(application_surface, display_get_width(), display_get_height());
    });
}