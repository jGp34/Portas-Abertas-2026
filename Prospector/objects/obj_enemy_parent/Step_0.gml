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
        // Posição: Como a origem é Top-Center, o centro verdadeiro
        // fica no "x" normal, mas o "y" tem que descer metade da altura atual.
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
        
        // Marca que o momento do golpe passou, para não checar de novo nesse ataque
        attack_hit = true; 
        
        // RECALCULA A DISTÂNCIA: O jogador ainda está aqui?
        var _meu_chao = bbox_bottom;
        var _player_chao = obj_player.bbox_bottom;
        var _dist_impacto = point_distance(x, _meu_chao, obj_player.x, _player_chao);
        
        // Se o jogador ainda estiver dentro do alcance (com uma margem de +5 pixels para o "fio da lâmina")
        if (_dist_impacto <= attack_dist + 5) {
            global.player_hp -= damage;
            show_debug_message("Golpe acertou! Dano: " + string(damage));
            
            // TOCA SOM DE ACERTO
            if (snd_hit != -1) {
                audio_play_sound(snd_hit, 1, false);
            }
            
        } else {
            // Se o jogador saiu do alcance enquanto o inimigo levantava a arma
            show_debug_message("Jogador desviou do ataque!");
            
            // TOCA SOM DE ERRO/SWING USANDO A VARIÁVEL
            if (snd_miss != -1) {
                var _miss_snd = audio_play_sound(snd_miss, 1, false);
                audio_sound_pitch(_miss_snd, snd_pitch); 
            }
        }
    } // <--- ESTA CHAVE ESTAVA FALTANDO NO SEU CÓDIGO!

    // Se a animação de ataque terminou, volta para idle
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
var _folga = 8; // <--- O SEGREDO! 8 pixels de folga para a parede

// DENTRO DO ALCANCE DE ATAQUE (Para de andar)
if (_dist <= attack_dist) {
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
    
    var _dir = point_direction(x, _meu_chao, obj_player.x, _player_chao);
    var _hspd = lengthdir_x(move_spd, _dir);
    var _vspd = lengthdir_y(move_spd, _dir);
    
    // --- COLISÃO HORIZONTAL (Perseguição) ---
    // Adiciona o buffer (sinal de _hspd * folga) para parar ANTES de encostar na parede
    if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
        while (!place_meeting(x + sign(_hspd), y, obj_barrier)) {
            x += sign(_hspd);
        }
        _hspd = 0;
    }
    x += _hspd;

    // --- COLISÃO VERTICAL (Perseguição) ---
    if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
        while (!place_meeting(x, y + sign(_vspd), obj_barrier)) {
            y += sign(_vspd);
        }
        _vspd = 0;
    }
    y += _vspd;
    
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
    image_yscale = base_scale;
}
// FORA DA VISÃO (Patrulhando ou Parado)
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
            
            // --- A SUA SOLUÇÃO: BATE E VOLTA ---
            // Usa o mesmo buffer na patrulha para dar meia volta ANTES de grudar na parede
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
    } else {
        state = "idle";
        sprite_index = spr_idle;
    }
}