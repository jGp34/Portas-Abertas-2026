depth = -bbox_bottom;
// 1. CHECAGEM DE MORTE (Mesmo código do pai para garantir as Souls)
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_death;
        image_index = 0; 
        
        // CORREÇÃO AQUI: Usar a variável do Parent que configuramos no Create
        if (snd_death != -1) audio_play_sound(snd_death, 1, false);
    }
    
    if (image_index >= image_number - 1) {
        var _meu_centro_x = x;
        var _meu_centro_y = y + (sprite_height / 2);
        var _soul = instance_create_layer(_meu_centro_x, _meu_centro_y, "Instances", obj_loot_soul);
        _soul.quantidade = souls_para_dropar;
        
        var _final_scale = 0.15 * souls_scale_mult; // Ajuste para o tamanho que você definiu antes
        _soul.image_xscale = _final_scale;
        _soul.image_yscale = _final_scale;
        
        instance_destroy();
    }
    exit; 
}

// 2. CHECAGEM DE DESTINO E FADE (Sumir)
if (is_fading) {
    image_alpha -= 0.05; // Fica transparente bem rápido
    if (image_alpha <= 0) {
        instance_destroy(); // Some sem dropar souls
    }
    exit; // Impede ele de andar ou dropar itens enquanto some
}

var _dist_destino = point_distance(x, y, destino_x, destino_y);
if (_dist_destino < 10) {
    is_fading = true; // Chegou! Começa a sumir.
}

// 3. SISTEMA DE HIT E DROP DE RECURSOS
if (hp < prev_hp) {
    // Ele tomou dano neste frame!
    var _dano_tomado = prev_hp - hp;
    prev_hp = hp;
    
    // ---> NOVIDADE: Acelera no primeiro golpe! <---
    if (!foi_atacado) {
        foi_atacado = true; // Trava para ele correr sem parar
        move_spd += 0.5;    // Acelera um pouco (pode ajustar esse valor!)
    }
    
    // --- LÓGICA DE PROBABILIDADES ---
    var _chance_carvao = 0, _chance_ferro = 0, _chance_ouro = 0;
    
    if (meu_numero_spawn <= 2) { 
        _chance_carvao = 50; 
    } 
    else if (meu_numero_spawn <= 4) { 
        _chance_carvao = 70; _chance_ferro = 25; 
    } 
    else if (meu_numero_spawn <= 6) { 
        _chance_carvao = 85; _chance_ferro = 50; _chance_ouro = 25; 
    } 
    else { 
        _chance_carvao = 100; _chance_ferro = 75; _chance_ouro = 50; 
    }
    
    // ========================================================
    // A MÁGICA ACONTECE AQUI: CÁLCULO DOS "HITS VIRTUAIS"
    // Divide o dano por 5 (dano base). O "max(1, ...)" garante 
    // que se o dano for menor que 5, ele ainda role pelo menos 1 vez.
    // ========================================================
    var _hits_virtuais = max(1, round(_dano_tomado / 5)); 
    
    var _dropou_algo = false; // Começa assumindo que deu azar
    
    // Roda a roleta de drops várias vezes dependendo da força do golpe!
    for (var i = 0; i < _hits_virtuais; i++) {
        
        if (random(100) < _chance_carvao) { 
            global.carvao += global.mine_yield;  
            _dropou_algo = true; 
        }
        if (random(100) < _chance_ferro) { 
            global.iron += global.mine_yield;  
            _dropou_algo = true; 
        }
        if (random(100) < _chance_ouro) { 
            global.gold += global.mine_yield;  
            _dropou_algo = true; 
        }
    }
    
    // Opcional: Toca o som e mostra no console SOMENTE se caiu algo.
    // Ele fica FORA do "for" para não tocar o som 10 vezes no mesmo milissegundo e estourar o ouvido do jogador!
    if (_dropou_algo) {
        audio_play_sound(sfx_kobold_drop, 1, false);
        show_debug_message("Kobold apanhou feio! Roletas giradas: " + string(_hits_virtuais));
    }
}
// 4. SISTEMA DE MOVIMENTO
if (!foi_atacado) {
    // Alterna entre andar e parar
    move_timer -= 1;
    if (move_timer <= 0) {
        is_moving = !is_moving;
        move_timer = irandom_range(0.5 * 60, 2 * 60); // Reseta timer 0.5s a 2.0s
    }
} else {
    is_moving = true; // Se tomou porrada, corre direto!
}

if (is_moving) {
    sprite_index = spr_walk;
    var _dir = point_direction(x, y, destino_x, destino_y);
    var _hspd = lengthdir_x(move_spd, _dir);
    var _vspd = lengthdir_y(move_spd, _dir);
    
    // --- SEM COLISÃO FÍSICA ---
    // Ele apenas anda livremente na direção do destino!
    x += _hspd;
    y += _vspd;
    
    // Vira para o lado que está andando
    if (abs(_hspd) > 0.1) image_xscale = sign(_hspd) * base_scale;
} else {
    sprite_index = spr_idle;
}