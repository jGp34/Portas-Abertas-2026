if (!instance_exists(obj_player)) exit;

// --- 1. ESTADO DE MORTE ---
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_death;
        image_index = 0; // Garante que a animação comece do início
    }
    
    // Se a animação de morte chegou ao último frame
    if (image_index >= image_number - 1) {
        show_debug_message("Inimigo destruído!");
        instance_destroy();
    }
    exit; // O "exit" impede que o inimigo continue andando/atacando depois de morto
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
        } else {
            // Se o jogador saiu do alcance enquanto o inimigo levantava a arma
            show_debug_message("Jogador desviou do ataque!");
        }
    }

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

// DENTRO DO ALCANCE DE ATAQUE (Para de andar)
if (_dist <= attack_dist) {
    
    // Inicia o ataque se estiver disponível
    if (can_attack) {
        state = "attack";
        sprite_index = spr_attack;
        image_index = 0; 
        
        // PREPARA O GOLPE: Reseta a variável de acerto
        attack_hit = false; 
        
        // Iniciar Cooldown
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
    
    x += lengthdir_x(move_spd, _dir);
    y += lengthdir_y(move_spd, _dir);
    
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
    image_yscale = base_scale;
}
// FORA DA VISÃO (Parado)
else {
    state = "idle";
    sprite_index = spr_idle;
}