// --- obj_cutscene_manager -> Step ---

// =======================================================
// 1. TELA CHEIA (F11)
// =======================================================
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);

    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) {
            surface_resize(application_surface, display_get_width(), display_get_height());
        } else {
            surface_resize(application_surface, window_get_width(), window_get_height());
        }
    });
}

// =======================================================
// 2. CONTROLES DA CUTSCENE (Enter = Pular Tudo)
// =======================================================

// ---> PULAR TUDO (Enter) <---
if (keyboard_check_pressed(vk_enter)) {
    if (target_room != noone) {
        audio_stop_all(); // Garante que a música pare ao pular
        room_goto(target_room);
    }
    exit; // Interrompe o resto do código
}

// =======================================================
// 3. MÁQUINA DE ESTADOS (Reprodução Automática)
// =======================================================
if (array_length(scenes) > 0) {
    switch (state) {
        case "fade_in":
            fade_alpha -= fade_speed;
            if (fade_alpha <= 0) {
                fade_alpha = 0;
                state = "waiting";
            }
            break;
            
        case "waiting":
            timer++;
            if (timer >= scenes[current_scene].dur) {
                state = "fade_out";
            }
            break;
            
        case "fade_out":
            fade_alpha += fade_speed;
            if (fade_alpha >= 1) {
                fade_alpha = 1;
                
                current_scene++;
                if (current_scene < array_length(scenes)) {
                    timer = 0;
                    state = "fade_in";
                } else {
                    // Acabou a cutscene naturalmente
                    if (target_room != noone) {
                        audio_stop_all(); // Garante que a música pare ao terminar
                        room_goto(target_room);
                    }
                }
            }
            break;
    }
}