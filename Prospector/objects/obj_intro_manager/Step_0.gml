// --- obj_intro_manager -> Step ---

// =======================================================
// 1. TELA CHEIA (F11) - Mesma lógica do HUD
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
// 2. PULAR INTRO TODA (Espaço ou Enter)
// =======================================================
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    room_goto(target_room);
    exit; // Interrompe o resto do código para evitar conflitos no frame
}

// =======================================================
// 3. MÁQUINA DE ESTADOS (Reprodução Automática)
// =======================================================
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
                room_goto(target_room);
            }
        }
        break;
}