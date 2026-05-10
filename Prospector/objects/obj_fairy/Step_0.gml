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
// Ela tenta ir para um ponto "atrás" e um pouco "acima" do ombro do jogador
var _lado_ombro = (obj_player.image_xscale > 0) ? -30 : 30;
var _alvo_x = obj_player.x + _lado_ombro;
var _alvo_y = obj_player.y - 25;

// Movimentação suave (Lerp aproxima aos poucos em vez de teleportar)
x = lerp(x, _alvo_x, 0.08);
y = lerp(y, _alvo_y, 0.08);

// --- 2. LÓGICA DE MIRA E ATAQUE ---
if (state == "fly") {
    sprite_index = spr_fairy_fly;
    
    // Procura o inimigo mais próximo
    var _enemy = instance_nearest(x, y, obj_enemy_parent);
    
    // Vira pro inimigo se ele existir, senão vira pra onde o jogador tá olhando
    if (_enemy != noone && point_distance(x, y, _enemy.x, _enemy.y) <= global.fairy_vision) {
        
        // Vira para o inimigo respeitando a escala da fada
        image_xscale = (sign(_enemy.x - x) == 0 ? 1 : sign(_enemy.x - x)) * base_scale;
        
        // Timer de ataque
        shoot_timer -= 1;
        if (shoot_timer <= 0) {
            // Apenas PREPARA o ataque e muda de estado!
            state = "attack";
            sprite_index = spr_fairy_attack;
            image_index = 0;
            shot_fired = false; // Destrava o tiro para essa nova animação
        }
    } else {
        // Se não tiver inimigo perto, vira junto com o player!
        var _player_dir = sign(obj_player.image_xscale);
        if (_player_dir != 0) {
            image_xscale = _player_dir * base_scale;
        }
    }
} 
// --- 3. ANIMAÇÃO DE ATAQUE ---
else if (state == "attack") {
    
    // ---> NOVIDADE: Dispara e faz som em 60% da animação! <---
    if (image_index >= image_number * 0.6 && !shot_fired) {
        shot_fired = true; // Trava para não atirar 2x
        
        // Pega o inimigo novamente (caso ele tenha se movido)
        var _enemy = instance_nearest(x, y, obj_enemy_parent);
        
        // --- AJUSTE DA POSIÇÃO DO TIRO ---
        var _tiro_x = x + (15 * sign(image_xscale));
        var _tiro_y = y; 
        
        // Cria a magia teleguiada na nova posição
        var _proj = instance_create_layer(_tiro_x, _tiro_y, "Instances", obj_projectile_fairy);
        _proj.target = _enemy;
        _proj.damage = global.fairy_damage;
        
        // Toca o som do disparo
        audio_play_sound(sfx_fairy_attack, 1, false);
    }
    
    // Quando a animação termina, volta a voar e reseta o relógio
    if (image_index >= image_number - 1) {
        state = "fly";
        shoot_timer = global.fairy_atk_speed; // Reinicia o timer com a velocidade do upgrade atual!
    }
}
// --- 4. CONTROLE DA VELOCIDADE DA ANIMAÇÃO ---
if (state == "attack") {
    // Acelera a animação de ataque proporcionalmente ao nível do upgrade!
    // Ex: 120 (base) / 30 (atual) = Velocidade 4x mais rápida.
    image_speed = (120 / global.fairy_atk_speed); 
} else {
    // Se estiver só voando ou morta, a animação roda na velocidade normal.
    image_speed = 1; 
}