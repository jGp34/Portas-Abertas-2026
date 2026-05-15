if (keyboard_check_pressed(vk_escape)) {
    if (!global.is_paused) {
        global.is_paused = true;
        pause_state = "main"; 
        pause_selected = 0; 
        
        pause_sprite = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);
        instance_deactivate_all(true); 
        audio_pause_all(); 
    } else {
        if (pause_state == "controls") {
            pause_state = "main"; 
        } else {
            global.is_paused = false;
            if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
            instance_activate_all();
            audio_resume_all();
        }
    }
}

if (global.is_paused) {
    if (pause_state == "main") {
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            pause_selected--;
            if (pause_selected < 0) pause_selected = array_length(pause_options) - 1; 
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            pause_selected++;
            if (pause_selected >= array_length(pause_options)) pause_selected = 0; 
        }
        
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
            if (pause_selected == 0) {
                global.is_paused = false;
                if (sprite_exists(pause_sprite)) sprite_delete(pause_sprite);
                instance_activate_all();
                audio_resume_all();
            } 
            else if (pause_selected == 1) {
                pause_state = "controls"; 
            } 
            else if (pause_selected == 2) {
                game_end(); 
            }
        }
    } 
    else if (pause_state == "controls") {
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
            pause_state = "main";
        }
    }
}