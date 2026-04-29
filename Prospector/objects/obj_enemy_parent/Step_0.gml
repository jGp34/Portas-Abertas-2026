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

// --- 2. VERIFICAR FIM DO ATAQUE ---
if (state == "attack") {
    // Se a animação de ataque terminou, volta para idle para reavaliar
    if (image_index >= image_number - 1) {
        state = "idle";
    } else {
        exit; // O "exit" impede que o inimigo ande enquanto está no meio da animação de ataque
    }
}

// --- 3. LÓGICA DE MOVIMENTO E ATAQUE ---
var _dist = point_distance(x, y, obj_player.x, obj_player.y);

// DENTRO DO ALCANCE DE ATAQUE (Para de andar)
if (_dist <= attack_dist) {
    
    // Tem ataque disponível?
    if (can_attack) {
        state = "attack";
        sprite_index = spr_attack;
        image_index = 0; // Começa a animação de ataque do zero
        
        // Aplicar dano ao jogador
        global.player_hp -= damage;
        
        // Iniciar Cooldown
        can_attack = false;
        alarm[0] = attack_cooldown; 
        
        show_debug_message("Inimigo atacou! Dano: " + string(damage));
    } 
    // Não pode atacar (em Cooldown)? Fica parado esperando.
    else {
        state = "idle";
        sprite_index = spr_idle;
    }
    
    // Mantém o inimigo olhando para o jogador, mas evita girar feito louco
    // se estiverem no mesmo exato pixel (usando uma margem de 1 pixel)
    if (abs(obj_player.x - x) > 1) {
        image_xscale = sign(obj_player.x - x) * base_scale;
    }
    image_yscale = base_scale;
}
// FORA DO ALCANCE DE ATAQUE, MAS DENTRO DA VISÃO (Perseguindo)
else if (_dist < detect_radius) {
    state = "walk";
    sprite_index = spr_walk; 
    
    var _dir = point_direction(x, y, obj_player.x, obj_player.y);
    
    // Movimentação simples
    x += lengthdir_x(move_spd, _dir);
    y += lengthdir_y(move_spd, _dir);
    
    // Girar o sprite (com a mesma margem de segurança de 1 pixel)
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