depth = -bbox_bottom;
if (!instance_exists(obj_player)) exit;

// --- 1. ESTADO DE MORTE ---
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_death;
        image_index = 0; 
        
        if (snd_death != -1) {
            audio_play_sound(snd_death, 1, false);
        }
    }
    
    // Se a animação de morte chegou ao último frame
    if (image_index >= image_number - 1) {
        
        // --- CORREÇÃO DA POSIÇÃO E ESCALA DA SOUL ---
        var _meu_centro_x = x;
        var _meu_centro_y = y + (sprite_height / 2);
        
        var _soul = instance_create_layer(_meu_centro_x, _meu_centro_y, "Instances", obj_loot_soul);
        
        _soul.quantidade = souls_para_dropar;
        
        // Tamanho ignorando a escala do inimigo, usando apenas o multiplicador!
        var _final_scale = 0.15 * souls_scale_mult;
        _soul.image_xscale = _final_scale;
        _soul.image_yscale = _final_scale;
        
        show_debug_message("Inimigo destruído! Dropou " + string(souls_para_dropar) + " souls.");
        instance_destroy();
    }
    exit; 
}

// --- 2. LÓGICA DURANTE O ATAQUE ---
if (state == "attack") {
    
    // O MOMENTO DO IMPACTO: Quando a animação chega a 60% (0.6)
    if (image_index >= image_number * 0.5) && (!attack_hit) {
        
        attack_hit = true; 
        
        // RECALCULA A DISTÂNCIA: O jogador ainda está aqui?
        var _meu_chao = bbox_bottom;
        var _player_chao = obj_player.bbox_bottom;
        var _dist_impacto = point_distance(x, _meu_chao, obj_player.x, _player_chao);
        
        if (_dist_impacto <= attack_dist + 5) {
            global.player_hp -= damage;
            show_debug_message("Golpe acertou! Dano: " + string(damage));
            
            if (snd_hit != -1) {
                audio_play_sound(snd_hit, 1, false);
            }
            
        } else {
            show_debug_message("Jogador desviou do ataque!");
            if (snd_miss != -1) {
                var _miss_snd = audio_play_sound(snd_miss, 1, false);
                audio_sound_pitch(_miss_snd, snd_pitch); 
            }
        }
    } 

    if (image_index >= image_number - 1) {
        state = "idle";
    } else {
        exit; // Impede que o inimigo ande enquanto está atacando
    }
}

// --- 3. LÓGICA DE MOVIMENTO E ATAQUE ---
var _meu_chao = bbox_bottom;
var _player_chao = obj_player.bbox_bottom;
var _dist = point_distance(x, _meu_chao, obj_player.x, _player_chao);
var _folga = 8;

// DENTRO DO ALCANCE DE ATAQUE (Para de andar)
if (_dist <= attack_dist) {
    
    tempo_sem_ver = 0; // <--- ZERA O RELÓGIO AQUI TAMBÉM!
    retornando = false;
	limite_sem_ver = irandom_range(480, 720);
    if (can_attack) {
        state = "attack";
        sprite_index = spr_attack;
        image_index = 0; 
        attack_hit = false; 
        can_attack = false;
        alarm[0] = attack_cooldown; 
        show_debug_message("Inimigo começou a atacar!");
    } 
    else {
        state = "idle";
        sprite_index = spr_idle;
    }
    
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
    image_yscale = base_scale;
}
// FORA DO ALCANCE DE ATAQUE, MAS DENTRO DA VISÃO (Perseguindo)
else if (_dist < detect_radius) {
    state = "walk";
    sprite_index = spr_walk; 
    
	tempo_sem_ver = 0; // <--- ZERA O RELÓGIO AO VER O JOGADOR DE LONGE
    retornando = false;
    limite_sem_ver = irandom_range(480, 720);
	
    var _dir = point_direction(x, _meu_chao, obj_player.x, _player_chao);
    var _hspd = lengthdir_x(move_spd, _dir);
    var _vspd = lengthdir_y(move_spd, _dir);
    
    // --- COLISÃO HORIZONTAL (Perseguição) ---
    if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
        while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
        _hspd = 0;
    }
    x += _hspd;

    // --- COLISÃO VERTICAL (Perseguição) ---
    if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
        while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
        _vspd = 0;
    }
    y += _vspd;
    
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
    image_yscale = base_scale;
}
// FORA DA VISÃO (Patrulhando ou Parado/Voltando)
else {
    
    if (can_wander) {
        wander_timer -= 1;
        
        if (wander_timer <= 0) {
            if (wander_state == "idle") {
                wander_state = "walk";
                wander_timer = 120; 
                wander_dir = random(360); 
            } else {
                wander_state = "idle";
                wander_timer = 120; 
            }
        }
        
        if (wander_state == "walk") {
            state = "walk";
            sprite_index = spr_walk;
            
            var _hspd = lengthdir_x(move_spd * 0.5, wander_dir);
            var _vspd = lengthdir_y(move_spd * 0.5, wander_dir);
            
            var _check_x = x + _hspd + (sign(_hspd) * _folga);
            var _check_y = y + _vspd + (sign(_vspd) * _folga);
            
            if (place_meeting(_check_x, _check_y, obj_barrier)) {
                wander_dir += 180; 
            } else {
                x += _hspd;
                y += _vspd;
            }
            
            if (abs(_hspd) > 0.1) {
                image_xscale = sign(_hspd) * base_scale;
            }
            
        } else {
            state = "idle";
            sprite_index = spr_idle;
        }
    } // <--- ESTA CHAVE ESTAVA FALTANDO! ELA FECHA O "CAN WANDER"
    
    // SE NÃO PUDER WANDER (Inimigos normais que guardam posição)
    else {
        
        // 1. Se ainda NÃO está retornando, começa a contar os 10 segundos!
        if (!retornando) {
            state = "idle";
            sprite_index = spr_idle;
            
            tempo_sem_ver++; // Aumenta 1 frame no relógio
            
            // Deu 10 segundos! Muda a flag para voltar
            if (tempo_sem_ver >= limite_sem_ver) {
                retornando = true;
            }
        } 
        // 2. Se já deu 10 segundos e ele DEVE voltar:
        else {
            var _dist_spawn = point_distance(x, y, spawn_x, spawn_y);
            
            // Se ainda está longe de casa, caminha até lá
            if (_dist_spawn > 5) {
                state = "walk";
                sprite_index = spr_walk;
                
                var _dir = point_direction(x, y, spawn_x, spawn_y);
                var _hspd = lengthdir_x(move_spd, _dir);
                var _vspd = lengthdir_y(move_spd, _dir);
                
                // --- COLISÃO HORIZONTAL (Retorno) ---
                if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
                    while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
                    _hspd = 0;
                }
                x += _hspd;

                // --- COLISÃO VERTICAL (Retorno) ---
                if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
                    while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
                    _vspd = 0;
                }
                y += _vspd;
                
                // Vira para o lado que está andando
                if (abs(_hspd) > 0.1) {
                    image_xscale = sign(_hspd) * base_scale;
                }
            } 
            // Chegou em casa! Fica de guarda novamente.
            else {
                state = "idle";
                sprite_index = spr_idle;
                retornando = false; 
                tempo_sem_ver = 0; // Zera para caso o jogador passe e fuja de novo
				limite_sem_ver = irandom_range(480, 720);
            }
        }
    } // Fim do "else" (não pode fazer wander)
} // Fim do "else" geral (fora da visão)

// ==========================================
// 6. SISTEMA DE RESGATE UNIVERSAL (Anti-Stuck)
// ==========================================
// Se qualquer inimigo herdeiro inverter a sprite e entrar na parede, 
// ele escorrega como sabão de volta para o mapa!
if (place_meeting(x, y, obj_barrier)) {
    var _dir_centro = point_direction(x, y, room_width / 2, room_height / 2);
    x += lengthdir_x(2, _dir_centro);
    y += lengthdir_y(2, _dir_centro);
}