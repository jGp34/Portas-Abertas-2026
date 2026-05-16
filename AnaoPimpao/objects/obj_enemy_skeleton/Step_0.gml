depth = -bbox_bottom;
if (!instance_exists(obj_player)) exit;

// --- 1. ESTADO DE MORTE (Igual ao Pai) ---
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_death;
        image_index = 0; 
        if (snd_death != -1) audio_play_sound(snd_death, 1, false);
    }
    
    if (image_index >= image_number - 1) {
        var _meu_centro_x = x;
        var _meu_centro_y = y + (sprite_height / 2);
        var _soul = instance_create_layer(_meu_centro_x, _meu_centro_y, "Instances", obj_loot_soul);
        _soul.quantidade = souls_para_dropar;
        var _final_scale = 0.15 * souls_scale_mult;
        _soul.image_xscale = _final_scale;
        _soul.image_yscale = _final_scale;
        instance_destroy();
    }
    exit; 
}

// --- 2. LÓGICA DE ATAQUE (ATIRAR PROJÉTIL) ---
if (state == "attack") {
    
    // Dispara a magia/flecha nos 60% da animação
    if (image_index >= image_number * 0.5) && (!attack_hit) {
        attack_hit = true; 
        
        if (snd_miss != -1) {
            var _snd = audio_play_sound(snd_miss, 1, false);
            audio_sound_pitch(_snd, snd_pitch); 
        }
        
		// --- AJUSTE DA POSIÇÃO DO TIRO ---
        // Faz o tiro sair da frente dele (baseado em qual lado ele está olhando)
        var _tiro_x = x + (30 * sign(image_xscale)); 
        
        // Coloque apenas "y" em vez de "y - 15". 
        // Se ainda ficar baixo, tente "y - 5" até alinhar com a mão dele!
        var _tiro_y = y + 40; 
        
        // Cria o projétil na nova posição corrigida
        var _proj = instance_create_layer(_tiro_x, _tiro_y, "Instances", obj_projectile_skeleton);
        _proj.damage = damage;
        _proj.damage = damage;
    }

    if (image_index >= image_number - 1) {
        state = "idle";
        shoot_timer = shoot_cooldown; // Reseta o relógio do tiro!
    } else {
        exit; // Fica parado travado enquanto atira
    }
}

// --- 3. LÓGICA DE MOVIMENTO INTELIGENTE (Fuga e Aproximação) ---
var _meu_chao = bbox_bottom;
var _player_chao = obj_player.bbox_bottom;
var _dist = point_distance(x, _meu_chao, obj_player.x, _player_chao);
var _folga = 8;
var _hspd = 0;
var _vspd = 0;

// O relógio de atirar corre constantemente
if (shoot_timer > 0) shoot_timer--;

// ---> NOVA REGRA GERAL: SE TEM TIRO PRONTO E VÊ O JOGADOR, ATIRA! <---
if (shoot_timer <= 0 && _dist < detect_radius) {
    state = "attack";
    sprite_index = spr_attack;
    image_index = 0; 
    attack_hit = false;
}
// Se não está na hora de atirar, toma as decisões de movimento:
else if (state != "attack") { 
    
    // A. SE O JOGADOR ESTÁ PERTO DEMAIS (Fugir / Kiting)
    if (_dist < ideal_dist_min) {
        state = "walk";
        sprite_index = spr_walk;
        var _dir = point_direction(obj_player.x, _player_chao, x, _meu_chao); // OPOSTO DO JOGADOR
        _hspd = lengthdir_x(move_spd, _dir);
        _vspd = lengthdir_y(move_spd, _dir);
    }
    // B. SE O JOGADOR ESTÁ LONGE MAS NA VISÃO (Aproximar Lentamente)
    else if (_dist > ideal_dist_max && _dist < detect_radius) {
        state = "walk";
        sprite_index = spr_walk;
        var _dir = point_direction(x, _meu_chao, obj_player.x, _player_chao); // NA DIREÇÃO DO JOGADOR
        _hspd = lengthdir_x(move_spd * 0.7, _dir); // 0.7 faz ele andar mais devagar ao aproximar
        _vspd = lengthdir_y(move_spd * 0.7, _dir);
    }
    // C. SE ESTÁ NA DISTÂNCIA PERFEITA E A ARMA ESTÁ RECARREGANDO (Espera parada)
    else if (_dist >= ideal_dist_min && _dist <= ideal_dist_max) {
        state = "idle";
        sprite_index = spr_idle;
    }
    // D. JOGADOR FORA DA VISÃO (Patrulhando ou Parado)
    else {
        if (can_wander) {
            wander_timer -= 1;
            
            if (wander_timer <= 0) {
                if (wander_state == "idle") {
                    wander_state = "walk";
                    wander_timer = 120; // Anda por 2 segundos
                    wander_dir = random(360); // Sorteia uma direção
                } else {
                    wander_state = "idle";
                    wander_timer = 120; // Fica parado por 2 segundos
                }
            }
            
            if (wander_state == "walk") {
                state = "walk";
                sprite_index = spr_walk;
                
                _hspd = lengthdir_x(move_spd * 0.5, wander_dir);
                _vspd = lengthdir_y(move_spd * 0.5, wander_dir);
                
                if (abs(_hspd) > 0.1) {
                    image_xscale = sign(_hspd) * base_scale;
                }
                
            } else {
                state = "idle";
                sprite_index = spr_idle;
                _hspd = 0;
                _vspd = 0;
            }
        } else {
            state = "idle";
            sprite_index = spr_idle;
            _hspd = 0;
            _vspd = 0;
        }
    }
}

// --- 4. APLICAR COLISÕES ---
if (state == "walk") {
    // Colisão Horizontal
    if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
        while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
        _hspd = 0;
        // Se bateu na parede durante a patrulha, dá meia volta
        if (_dist >= detect_radius) wander_dir += 180;
    }
    x += _hspd;

    // Colisão Vertical
    if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
        while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
        _vspd = 0;
        // Se bateu na parede durante a patrulha, dá meia volta
        if (_dist >= detect_radius) wander_dir += 180;
    }
    y += _vspd;
}

// --- 5. OLHAR PARA O JOGADOR (SÓ SE ESTIVER VENDO ELE) ---
if (_dist < detect_radius) {
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
}
image_yscale = base_scale;