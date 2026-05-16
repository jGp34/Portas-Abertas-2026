// --- obj_cutscene_manager -> Step ---

// ---> 1. TELA CHEIA <---
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);
    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) { surface_resize(application_surface, display_get_width(), display_get_height()); } 
        else { surface_resize(application_surface, window_get_width(), window_get_height()); }
    });
}

// ---> 2. PULAR CUTSCENE <---
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (target_room != noone) {
        audio_stop_all(); 
        room_goto(target_room);
    }
    exit; 
}

// ---> 3. MÁQUINA DE ESTADOS <---
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
                    // Decide o rumo final!
                    if (show_credits) {
                        state = "credits";
                        fade_alpha = 0; // <--- CORREÇÃO AQUI! Remove a tela preta para revelar os créditos
                    } else {
                        if (target_room != noone) {
                            audio_stop_all(); 
                            room_goto(target_room);
                        }
                    }
                }
            }
            break;
            
		// ---> 4. CRÉDITOS SINCRONIZADOS <---
        case "credits":
            if (!speed_calculated) {
                draw_set_font(fnt_text);
                credits_total_height = 0;
                
                for (var i = 0; i < array_length(credits_data); i++) {
                    var _item = credits_data[i];
                    if (_item.tipo == "titulo_principal") credits_total_height += string_height(_item.texto) * 1.5 + 40;
                    else if (_item.tipo == "titulo") credits_total_height += string_height(_item.texto) * 1.2 + 20;
                    else if (_item.tipo == "nome") credits_total_height += string_height(_item.texto) + 40;
                    else if (_item.tipo == "agradecimento") credits_total_height += string_height(_item.texto) * 1.5 + 40;
                    else if (_item.tipo == "espaco") credits_total_height += 40;
                }
                
                // Mudança aqui: O ponto de parada agora é quando o texto sai totalmente da tela por cima
                var _ponto_saida = -credits_total_height - 100;
                var _distancia_total = (gui_height + 50) - _ponto_saida;
                
                var _tempo_restante_seg = 10;
                if (music_asset != noone && music_id != noone && audio_is_playing(music_id)) {
                    _tempo_restante_seg = audio_sound_length(music_asset) - audio_sound_get_track_position(music_id);
                    _tempo_restante_seg -= 1.0; // Deixa 1 segundo de margem
                    if (_tempo_restante_seg <= 0.1) _tempo_restante_seg = 0.1; 
                }
                
                var _tempo_frames = _tempo_restante_seg * game_get_speed(gamespeed_fps);
                credits_speed = _distancia_total / _tempo_frames;
                speed_calculated = true;
            }
            
            credits_y -= credits_speed; 
            
            // Inicia o Fade Out quando o "Obrigado por jogar" estiver quase sumindo no topo
            // (Ajustamos para começar o fade 200 pixels antes do fim total)
            if (credits_y <= -credits_total_height + 200) {
                fade_alpha = 0;               
                state = "fade_out_credits";   
            }
            break;
            
        // ---> 5. FADE OUT FINAL (COM MOVIMENTO!) <---
        case "fade_out_credits":
            // MANTÉM O MOVIMENTO: O texto continua subindo enquanto escurece!
            credits_y -= credits_speed; 
            
            fade_alpha += 0.01; // Escurece um pouco mais rápido para acompanhar o fim da música
            
            if (fade_alpha >= 1) {
                if (target_room != noone) {
                    audio_stop_all(); 
                    room_goto(target_room); 
                }
            }
            break;
    }
}