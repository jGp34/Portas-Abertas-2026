depth = -bbox_bottom;

// ==========================================
// 1. CHECAGEM DE MORTE (Apenas Almas)
// ==========================================
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
        
        // A alma continua usando a quantidade fixa estipulada no Create, sem sofrer ação do Yield
        _soul.quantidade = souls_para_dropar;
        
        var _final_scale = 0.15 * souls_scale_mult; 
        _soul.image_xscale = _final_scale;
        _soul.image_yscale = _final_scale;
        
        instance_destroy();
    }
    exit; 
}

// ==========================================
// 2. CHECAGEM DE DESTINO E FADE (Sumir)
// ==========================================
if (is_fading) {
    image_alpha -= 0.05; 
    if (image_alpha <= 0) {
        instance_destroy(); 
    }
    exit; 
}

var _dist_destino = point_distance(x, y, destino_x, destino_y);
if (_dist_destino < 10) {
    is_fading = true; 
}

// ==========================================
// 3. SISTEMA DE HIT E DROP DE RECURSOS
// ==========================================
if (hp < prev_hp) {
    var _dano_tomado = prev_hp - hp;
    prev_hp = hp;
    
    // Acelera no primeiro golpe para ficar mais escorregadio!
    if (!foi_atacado) {
        foi_atacado = true; 
        move_spd += 1.0; 
    }
    
    // --- LÓGICA DE PROBABILIDADES FIXAS E ALTAS ---
    var _chance_carvao = 100;
    var _chance_ferro = 75;
    var _chance_ouro = 50;
    
    var _hits_virtuais = max(1, round(_dano_tomado / 5)); 
    var _dropou_algo = false; 
    
    // O valor do drop de minérios obedece ao seu "Mine Yield"
    var _qnt_drop = global.mine_yield;
    
    for (var i = 0; i < _hits_virtuais; i++) {
        
        if (random(100) < _chance_carvao) { 
            global.carvao += _qnt_drop;  
            _dropou_algo = true; 
        }
        if (random(100) < _chance_ferro) { 
            global.iron += _qnt_drop;  
            _dropou_algo = true; 
        }
        if (random(100) < _chance_ouro) { 
            global.gold += _qnt_drop;  
            _dropou_algo = true; 
        }
    }
    
    if (_dropou_algo) {
        audio_play_sound(sfx_kobold_drop, 1, false);
        show_debug_message("Kobold apanhou! Roletas: " + string(_hits_virtuais) + " | Yield usado: " + string(_qnt_drop));
    }
}

// ==========================================
// 4. SISTEMA DE MOVIMENTO
// ==========================================
if (!foi_atacado) {
    move_timer -= 1;
    if (move_timer <= 0) {
        is_moving = !is_moving;
        move_timer = irandom_range(0.5 * 60, 2 * 60); 
    }
} else {
    is_moving = true; // Se tomou porrada, corre direto!
}

if (is_moving) {
    sprite_index = spr_walk;
    var _dir = point_direction(x, y, destino_x, destino_y);
    var _hspd = lengthdir_x(move_spd, _dir);
    var _vspd = lengthdir_y(move_spd, _dir);
    
    x += _hspd;
    y += _vspd;
    
    if (abs(_hspd) > 0.1) image_xscale = sign(_hspd) * base_scale;
} else {
    sprite_index = spr_idle;
}