// --- obj_outro_manager -> Step ---

// ---> 1. TELA CHEIA (F11) <---
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);
    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) { surface_resize(application_surface, display_get_width(), display_get_height()); } 
        else { surface_resize(application_surface, window_get_width(), window_get_height()); }
    });
}

// ---> 2. PULAR CUTSCENE (ENTER / ESPAÇO) <---
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (target_room != noone) {
        audio_stop_all(); 
        room_goto(target_room);
    }
    exit; 
}

// ---> 3. MÁQUINA DE ESTADOS DA CUTSCENE E CRÉDITOS <---
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
                // Se ainda tem imagens na playlist, passa para a próxima
                if (current_scene < array_length(scenes)) {
                    timer = 0;
                    state = "fade_in";
                } else {
                    // Se as imagens acabaram, passa para o estado dos créditos
                    if (show_credits) {
                        state = "credits";
                    } else {
                        if (target_room != noone) {
                            audio_stop_all(); 
                            room_goto(target_room);
                        }
                    }
                }
            }
            break;
            
        // ---> 4. ESTADO DOS CRÉDITOS ROLANTES <---
        case "credits":
            credits_y -= 1.0; // Velocidade suave e cinematográfica da rolagem
            
            // Se o texto já subiu tudo (passou da altura total calculada lá no Create)
            if (credits_y < -credits_total_height - 100) {
                if (target_room != noone) {
                    audio_stop_all(); // Para a música
                    room_goto(target_room); // Leva para a sala de Upgrades
                }
            }
            break;
    }
}