depth = -bbox_bottom;
var _fps = game_get_speed(gamespeed_fps);

switch (state) {
    // --- 1. CRESCIMENTO ---
    case "growing":
        mask_index = sprite_base;
        if (image_index >= image_number - 1) {
            image_speed = 0;
            image_index = image_number - 1;
            state = "idle";
        }
        break;

    // --- 2. PRONTA PARA MINERAR ---
    case "idle":
        if (!instance_exists(obj_player)) break;
        
        if (global.player_hp > 0) {
            var _dist_x = 0;
            var _dist_y = 0;
            
            if (obj_player.bbox_right < bbox_left) {
                _dist_x = bbox_left - obj_player.bbox_right;
            } else if (obj_player.bbox_left > bbox_right) {
                _dist_x = obj_player.bbox_left - bbox_right;
            }
            
            if (obj_player.bbox_bottom < bbox_top) {
                _dist_y = bbox_top - obj_player.bbox_bottom;
            } else if (obj_player.bbox_top > bbox_bottom) {
                _dist_y = obj_player.bbox_top - bbox_bottom;
            }
            
            var _limite_laterais = 15;   
            var _limite_cima_baixo = 10; 
            var _movendo = keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D"));
            
            if (_dist_x <= _limite_laterais && _dist_y <= _limite_cima_baixo && keyboard_check(ord("E")) && !_movendo) {
                if (obj_player.sprite_index != spr_player_sword) {
                    timer_atual += global.mine_speed;
                    
                    if (obj_player.sprite_index != spr_player_axe) {
                        obj_player.sprite_index = spr_player_axe;
                        obj_player.image_index = 0;
                    }
                    
                    // --- QUANDO A ÁRVORE CAI ---
                    if (timer_atual >= tempo_mineracao_max) {
                        timer_atual = 0; 
                        global.wood += global.mine_yield;
                        
                        // TOCA O SOM DE DESTRUIÇÃO
                        audio_play_sound(sfx_player_destroy_tree, 1, false);
                        
                        if (instance_exists(obj_player)) {
                            obj_player.sprite_index = spr_player_still;
                            obj_player.image_index = 0;
                        }
                        
                        state = "falling";
                        sprite_index = sprite_fall;
                        image_index = 0;
                        image_speed = 1;
                        mask_index = spr_empty;
                        
                        if (obj_player.x <= x) {
                            image_xscale = -1;  
                        } else {
                            image_xscale = 1;   
                        }
                    }
                } else {
                    timer_atual = 0;
                }
            } else {
                timer_atual = 0; 
            }
        }
        break;

    // --- 3. ANIMAÇÃO DE QUEDA ---
    case "falling":
        if (image_index >= image_number - 1) {
            image_speed = 0;
            state = "waiting";
            regrow_timer = irandom_range(5 * _fps, 60 * _fps);
            mask_index = spr_empty; 
        }
        break;

    // --- 4. ESPERANDO PARA CRESCER ---
    case "waiting":
        regrow_timer -= 1;
        if (regrow_timer <= 0) {
            mask_index = sprite_base;
            if (place_meeting(x, y, obj_player)) {
                regrow_timer = irandom_range(5 * _fps, 30 * _fps);
                mask_index = spr_empty;
            } else {
                state = "growing";
                sprite_index = sprite_base;
                image_index = 0;
                image_speed = random_range(0.8, 1.2);
                image_xscale = 1;
            }
        }
        break;
}