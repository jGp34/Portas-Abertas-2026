depth = -bbox_bottom;
if (!instance_exists(obj_player)) exit;

// Se o jogador morreu, ela roda a animação de morte também
if (global.player_hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_fairy_death;
        image_index = 0;
    }
    
    if (image_index >= image_number - 1) {
        image_speed = 0; // Trava no último frame no chão
    }
    exit;
}

// --- 1. LÓGICA DE SEGUIR O PLAYER ---
var _lado_ombro = (obj_player.image_xscale > 0) ? -30 : 30;
var _alvo_x = obj_player.x + _lado_ombro;
var _alvo_y = obj_player.y - 25;

x = lerp(x, _alvo_x, 0.08);
y = lerp(y, _alvo_y, 0.08);

// --- FUNÇÃO PARA ENCONTRAR O ALVO VÁLIDO ---
// Como precisamos achar o alvo tanto no "fly" quanto no "attack", 
// fazemos a busca antes para não repetir código.
var _enemy = noone;
var _min_dist = global.fairy_vision; // Só aceita inimigos dentro da visão

with (obj_enemy_parent) {
    var _is_valid = true;
    
    // Se for o Cavaleiro (Boss), verifica o estado dele
    if (object_index == obj_enemy_knight) {
        // Se ele ainda está na introdução, ignora ele!
        if (state == "intro_walk" || state == "intro_wait") {
            _is_valid = false;
        }
    }
    
    // Se for um alvo válido, checa se é o mais próximo até agora
    if (_is_valid) {
        var _dist = point_distance(x, y, other.x, other.y);
        if (_dist <= _min_dist) {
            _min_dist = _dist; // Atualiza a menor distância
            _enemy = id;       // Define este como o alvo atual
        }
    }
}

// --- 2. LÓGICA DE MIRA E ATAQUE ---
if (state == "fly") {
    sprite_index = spr_fairy_fly;
    
    // Se encontrou um inimigo válido dentro do alcance
    if (_enemy != noone) {
        
        // Vira para o inimigo
        image_xscale = (sign(_enemy.x - x) == 0 ? 1 : sign(_enemy.x - x)) * base_scale;
        
        shoot_timer -= 1;
        if (shoot_timer <= 0) {
            state = "attack";
            sprite_index = spr_fairy_attack;
            image_index = 0;
            shot_fired = false; 
        }
    } else {
        // Se não tiver inimigo válido perto, vira junto com o player!
        var _player_dir = sign(obj_player.image_xscale);
        if (_player_dir != 0) {
            image_xscale = _player_dir * base_scale;
        }
    }
} 
// --- 3. ANIMAÇÃO DE ATAQUE ---
else if (state == "attack") {
    
    if (image_index >= image_number * 0.6 && !shot_fired) {
        shot_fired = true; 
        
        // Só atira se o inimigo não sumiu/morreu durante a animação de ataque
        if (_enemy != noone) {
            var _tiro_x = x + (15 * sign(image_xscale));
            var _tiro_y = y; 
            
            var _proj = instance_create_layer(_tiro_x, _tiro_y, "Instances", obj_projectile_fairy);
            _proj.target = _enemy;
            _proj.damage = global.fairy_damage;
            
            audio_play_sound(sfx_fairy_attack, 1, false);
        }
    }
    
    if (image_index >= image_number - 1) {
        state = "fly";
        shoot_timer = global.fairy_atk_speed; 
    }
}

// --- 4. CONTROLE DA VELOCIDADE DA ANIMAÇÃO ---
if (state == "attack") {
    image_speed = (120 / global.fairy_atk_speed); 
} else {
    image_speed = 1; 
}