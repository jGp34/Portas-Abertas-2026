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
// ---> ESTADO DOS CRÉDITOS ROLANTES <---
        case "credits":
            
            // 1. Calcula a velocidade exata APENAS na primeira frame dos créditos
            if (!speed_calculated && credits_text != "") {
                var _text_h = string_height(credits_text) * 2; 
                var _dist_total = gui_height + _text_h + 100; // Caminho total que o texto precisa percorrer
                
                var _tempo_restante_seg = 10; // Fallback caso a música já tenha acabado
                
                // Pega a duração total da música MENOS o tempo que já passou tocando as imagens
                if (music_asset != noone && music_id != noone && audio_is_playing(music_id)) {
                    _tempo_restante_seg = audio_sound_length(music_asset) - audio_sound_get_track_position(music_id);
                    if (_tempo_restante_seg <= 0.1) _tempo_restante_seg = 0.1; // Trava de segurança contra divisão por 0
                }
                
                // Converte os segundos restantes para Frames (ex: 30s * 60fps = 1800 frames)
                var _tempo_restante_frames = _tempo_restante_seg * game_get_speed(gamespeed_fps);
                
                // Distância dividida pelo Tempo dá a nossa Velocidade perfeita!
                credits_speed = _dist_total / _tempo_restante_frames;
                speed_calculated = true; 
            }
            
            // 2. Move o texto baseado na nova velocidade inteligente
            credits_y -= credits_speed; 
            
            // 3. Muda de sala quando tudo acabar
            if (credits_text != "") {
                var _text_h = string_height(credits_text) * 2; 
                
                // Verifica se o texto sumiu
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