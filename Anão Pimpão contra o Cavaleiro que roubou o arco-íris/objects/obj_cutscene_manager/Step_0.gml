// --- obj_cutscene_manager -> Step ---

// Tela cheia e pulo (Mantém igualzinho o seu)
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);
    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) { surface_resize(application_surface, display_get_width(), display_get_height()); } 
        else { surface_resize(application_surface, window_get_width(), window_get_height()); }
    });
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (target_room != noone) {
        audio_stop_all(); 
        room_goto(target_room);
    }
    exit; 
}

// MÁQUINA DE ESTADOS
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
                    // ---> NOVO: Verifica se deve exibir créditos ou acabar <---
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
            
        // ---> NOVO: Estado dos Créditos Rolantes <---
        case "credits":
            credits_y -= 1.5; // Velocidade da rolagem (Aumente se achar muito lento)
            
            // Calcula o tamanho do texto para saber a hora exata de mudar de sala
            if (credits_text != "") {
                var _text_h = string_height(credits_text) * 2; // *2 porque dobramos a escala na tela
                
                // Se o texto já subiu tudo e passou da tela, acaba o jogo!
                if (credits_y < -_text_h - 100) {
                    if (target_room != noone) {
                        audio_stop_all();
                        room_goto(target_room);
                    }
                }
            }
            break;
    }
}