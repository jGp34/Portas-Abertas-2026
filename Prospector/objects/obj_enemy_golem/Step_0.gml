if (!instance_exists(obj_player)) exit;

// Calcula a distância do Golem até o jogador (usando o chão como base)
var _meu_chao = bbox_bottom;
var _player_chao = obj_player.bbox_bottom;
var _dist_to_player = point_distance(x, _meu_chao, obj_player.x, _player_chao);

// --- 1. ESTADO DE MORTE ---
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_death;
        image_index = 0; 
        if (snd_death != -1) audio_play_sound(snd_death, 1, false);
    }
    
    // Animação de morte terminou
    if (image_index >= image_number - 1) {
        var _meu_centro_x = x;
        var _meu_centro_y = y + (sprite_height / 2);
        
        var _soul = instance_create_layer(_meu_centro_x, _meu_centro_y, "Instances", obj_loot_soul);
        _soul.quantidade = souls_para_dropar;
        
        // Aplica o multiplicador de escala solicitado (1.6)
        var _final_scale = 0.15 * souls_scale_mult;
        _soul.image_xscale = _final_scale;
        _soul.image_yscale = _final_scale;
        
        instance_destroy();
    }
    exit; 
}

// --- 2. CRONÔMETRO DE TIRO ---
if (shoot_timer > 0 && state != "attack") {
    shoot_timer--;
}

// NOVA REGRA: Se o tempo acabou E o jogador está no raio de visão (detect_radius)
if (shoot_timer <= 0 && state != "attack" && _dist_to_player <= detect_radius) {
    state = "attack";
    sprite_index = spr_attack;
    image_index = 0; 
    attack_hit = false;
}

// --- 3. LÓGICA DE ATAQUE (4 PROJÉTEIS CARDEAIS) ---
if (state == "attack") {
    
    // Dispara nos 50% da animação
    if (image_index >= image_number * 0.5) && (!attack_hit) {
        attack_hit = true; 
        
        if (snd_miss != -1) {
            var _snd = audio_play_sound(snd_miss, 1, false);
            audio_sound_pitch(_snd, snd_pitch); 
        }
        
        // Posição central "base" do Golem
        var _tiro_x_base = x; 
        var _tiro_y_base = y + (sprite_height / 2); // Ajuste de altura padrão (Cima e Baixo)
        
        // Array com os 4 ângulos: Direita, Cima, Esquerda, Baixo
        var _direcoes = [0, 90, 180, 270];
        
        for (var _i = 0; _i < 4; _i++) {
            var _tiro_y_final = _tiro_y_base;
            
            // SE O TIRO FOR PRA DIREITA (0) OU ESQUERDA (180)...
            if (_direcoes[_i] == 0 || _direcoes[_i] == 180) {
                // Abaixa o tiro em X pixels (Mude o 15 para mais ou menos conforme precisar!)
                _tiro_y_final += 15; 
            }
            
            var _proj = instance_create_layer(_tiro_x_base, _tiro_y_final, "Instances", obj_projectile_golem);
            _proj.damage = damage;
            _proj.direction = _direcoes[_i];
            _proj.image_angle = _proj.direction; // Vira a sprite na direção do tiro
        }
    }

    if (image_index >= image_number - 1) {
        state = "idle";
        shoot_timer = shoot_cooldown; // Reseta o relógio do tiro!
    } else {
        exit; // Fica travado parado enquanto ataca
    }
}

// --- 4. LÓGICA DE MOVIMENTO (APENAS WANDER - IGNORA O PLAYER) ---
var _folga = 8;
var _hspd = 0;
var _vspd = 0;

if (can_wander) {
    wander_timer -= 1;
    
    if (wander_timer <= 0) {
        if (wander_state == "idle") {
            wander_state = "walk";
            wander_timer = irandom_range(90, 150); // Anda por um tempo aleatório
            wander_dir = random(360); // Sorteia uma direção
        } else {
            wander_state = "idle";
            wander_timer = irandom_range(60, 120); // Fica parado um tempo
        }
    }
    
    if (wander_state == "walk") {
        state = "walk";
        sprite_index = spr_walk;
        
        // Usa a velocidade fixa (move_spd) para o wander, não metade como o parent
        _hspd = lengthdir_x(move_spd, wander_dir);
        _vspd = lengthdir_y(move_spd, wander_dir);
        
        if (abs(_hspd) > 0.1) {
            image_xscale = sign(_hspd) * base_scale;
        }
        
    } else {
        state = "idle";
        sprite_index = spr_still;
        _hspd = 0;
        _vspd = 0;
    }
}

// --- 5. APLICAR COLISÕES ---
if (state == "walk") {
    // Colisão Horizontal
    if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
        while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
        _hspd = 0;
        wander_dir += 180; // Dá meia volta ao bater na parede
    }
    x += _hspd;

    // Colisão Vertical
    if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
        while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
        _vspd = 0;
        wander_dir += 180; // Dá meia volta ao bater na parede
    }
    y += _vspd;
}

image_yscale = base_scale;