// --- obj_genie -> Step ---
var _fps = game_get_speed(gamespeed_fps);

// Só ajusta o depth se estiver na tela
if (visible) {
    depth = -bbox_bottom;
}

switch (state) {
    // ==========================================
    // 1. ESCONDIDO (Contando o tempo para nascer)
    // ==========================================
    case "hidden":
        spawn_timer -= 1;
        
        if (spawn_timer <= 0) {
            x = irandom_range(96, 1280);
            y = irandom_range(96, 672);
            
            while (place_meeting(x, y, obj_colision)) {
                x = irandom_range(96, 1280);
                y = irandom_range(96, 672);
            }
            
            visible = true;
            sprite_index = spr_genie_still;
            image_index = 0;
            image_speed = 1;
            
            active_timer = irandom_range(9, 15) * _fps; 
            state = "active";
            
            show_debug_message("Gênio apareceu na posição: " + string(x) + ", " + string(y));
        }
        break;

    // ==========================================
    // 2. ATIVO (Aguardando o jogador)
    // ==========================================
    case "active":
        active_timer -= 1;
        
        // --- Interação e Rotação do Jogador ---
        if (instance_exists(obj_player)) {
            
            var _dir = sign(obj_player.x - x);
            if (_dir != 0) {
                image_xscale = _dir * 0.3;
            }
            
            var _dist = point_distance(x, y, obj_player.x, obj_player.y);
            
            if (_dist <= 50 && keyboard_check_pressed(ord("E"))) {
                
                var _recurso = choose("wood", "iron", "carvao", "gold", "souls");
                var _ganho = 0;
                
                if (_recurso == "wood") { _ganho = ceil(global.wood * 0.15); global.wood += _ganho; } 
                else if (_recurso == "iron") { _ganho = ceil(global.iron * 0.15); global.iron += _ganho; } 
                else if (_recurso == "carvao") { _ganho = ceil(global.carvao * 0.15); global.carvao += _ganho; } 
                else if (_recurso == "gold") { _ganho = ceil(global.gold * 0.15); global.gold += _ganho; } 
                else if (_recurso == "souls") { _ganho = ceil(global.souls * 0.15); global.souls += _ganho; }
                
                show_debug_message("Gênio ativado! +15% de " + _recurso + " (Ganho: " + string(_ganho) + ")");
                audio_play_sound(sfx_genie_like, 1, false);
                
                state = "reward";
                sprite_index = spr_genie_like;
                image_index = 0;
            }
        }
        
        // --- Tempo esgotado (O Player não chegou a tempo) ---
        if (active_timer <= 0 && state == "active") {
            state = "timeout";
            sprite_index = spr_genie_death;
            image_index = 0;
            
            var _cam = view_camera[0];
            var _cam_x = camera_get_view_x(_cam);
            var _cam_y = camera_get_view_y(_cam);
            var _cam_w = camera_get_view_width(_cam);
            var _cam_h = camera_get_view_height(_cam);
            
            if (point_in_rectangle(x, y, _cam_x, _cam_y, _cam_x + _cam_w, _cam_y + _cam_h)) {
                audio_play_sound(sfx_genie_disappear, 1, false);
            }
        }
        break;

    // ==========================================
    // 3. RECOMPENSA (Animação de Like rodando)
    // ==========================================
    case "reward":
        // Quando a animação do Like terminar...
        if (image_index >= image_number - 1) {
            // ...Ele entra no estado de Death para ir embora
            state = "timeout";
            sprite_index = spr_genie_death;
            image_index = 0;
            
            // Toca o som de desaparecer (Assumindo que o jogador tá do lado dele)
            audio_play_sound(sfx_genie_disappear, 1, false);
        }
        break;

    // ==========================================
    // 4. INDO EMBORA (Animação de Death rodando)
    // ==========================================
    case "timeout":
        // Espera a animação de sumir acabar
        if (image_index >= image_number - 1) {
            visible = false;
            x = -1000;
            y = -1000;
            state = "hidden";
            
            // Escolhe um novo tempo de 45s até 1m45s para aparecer de novo
            spawn_timer = (45 + irandom(60)) * _fps; 
        }
        break;
}