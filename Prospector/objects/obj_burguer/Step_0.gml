if (!instance_exists(obj_player)) exit;

// 1. SE O JOGADOR MORREU, FICA PARADO
if (global.player_hp <= 0) {
    state = "idle";
    sprite_index = spr_burguer_still;
    image_speed = 0;
    exit;
}

// --- 2. LÓGICA DE SEGUIR O PLAYER ---
// Diferente da fada (que voa), o hambúrguer vai pelo chão.
// Vamos colocá-lo um pouco mais atrás e no nível dos pés do jogador.
var _lado_costas = (obj_player.image_xscale > 0) ? -40 : 40;
var _alvo_x = obj_player.x + _lado_costas;
var _alvo_y = obj_player.y; // Mantém a altura do jogador (no chão)

// Vira para o lado que está andando ou para o lado do player
if (abs(_alvo_x - x) > 2) {
    image_xscale = sign(_alvo_x - x) * base_scale;
} else {
    var _player_dir = sign(obj_player.image_xscale);
    if (_player_dir != 0) image_xscale = _player_dir * base_scale;
}

// --- 3. MÁQUINA DE ESTADOS (Parado, Pulando, Curando) ---
if (state == "idle" || state == "jump") {
    
    // Calcula a distância real entre o hambúrguer e o lugar dele
    var _dist = point_distance(x, y, _alvo_x, _alvo_y);
    
    // --- SISTEMA DE MOVIMENTO ANTI-TELEPORTE ---
    var _max_spd = 4; // Velocidade máxima normal pertinho de você
    
    // Se ficou muito para trás (mais de 60 pixels), ele acelera para alcançar!
    if (_dist > 60) {
        _max_spd = 10; // Velocidade do "pulo rápido"
    }
    
    // Calcula a intenção de movimento do Lerp
    var _move_x = (_alvo_x - x) * 0.08;
    var _move_y = (_alvo_y - y) * 0.08;
    
    // Aplica o movimento com limite (clamp) para evitar o salto de teleporte
    x += clamp(_move_x, -_max_spd, _max_spd);
    y += clamp(_move_y, -_max_spd, _max_spd);
    
    // Se está longe do alvo, toca a animação de pulo, senão fica parado
    if (_dist > 5) {
        state = "jump";
        sprite_index = spr_burguer_jump;
    } else {
        state = "idle";
        sprite_index = spr_burguer_still;
    }
    
    // Temporizador da Cura
    heal_timer -= 1;
    
    // Só começa a curar se o timer zerou E se o jogador estiver precisando de vida!
    if (heal_timer <= 0 && global.player_hp < global.max_hp) {
        state = "heal";
        sprite_index = spr_burguer_heal;
        image_index = 0;
        healed_this_cycle = false; // Destrava a cura para essa animação
    }
}

// --- 4. ANIMAÇÃO DE CURA ---
else if (state == "heal") {
    
    // No meio (50%) da animação, aplica a cura!
    if (image_index >= image_number * 0.35 && !healed_this_cycle) {
        healed_this_cycle = true; // Trava
        
        // Cura o jogador
        global.player_hp += global.burguer_heal_amount;
        
        // Garante que a vida não passe do máximo
        if (global.player_hp > global.max_hp) {
            global.player_hp = global.max_hp;
        }
        
        // Toca o som (opcional)
        audio_play_sound(sfx_burguer_heal, 1, false);
        show_debug_message("Burgão curou " + string(global.burguer_heal_amount) + " de HP!");
    }
    
    // Quando a animação acaba, volta a seguir e reseta o relógio
    if (image_index >= image_number - 1) {
        state = "idle";
        heal_timer = global.burguer_heal_speed; 
    }
}

// --- 5. CONTROLE DA VELOCIDADE DA ANIMAÇÃO ---
if (state == "heal") {
    // Escala a animação de cura baseado no upgrade (Exemplo: base de 300 frames = 5 segundos)
    image_speed = (300 / global.burguer_heal_speed); 
} 
else if (state == "jump") {
    // Se estiver muito para trás, ele pula com a animação mais frenética!
    if (point_distance(x, y, _alvo_x, _alvo_y) > 60) {
        image_speed = 2; // Animação de pulo acelerada (2x mais rápido)
    } else {
        image_speed = 1; // Pulo normal
    }
}
else {
    // Parado
    image_speed = 1; 
}