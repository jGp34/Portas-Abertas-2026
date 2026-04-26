if (!instance_exists(obj_player)) exit;

var _dist = point_distance(x, y, obj_player.x, obj_player.y);

// 1. ESTADO DE PERSEGUIÇÃO
if (_dist < detect_radius && _dist > attack_dist) {
    var _dir = point_direction(x, y, obj_player.x, obj_player.y);
    
    // Movimentação simples (desconsiderando colisões por enquanto para focar na lógica)
    x += lengthdir_x(move_spd, _dir);
    y += lengthdir_y(move_spd, _dir);
    
    // Girar o sprite
    if (obj_player.x != x) image_xscale = sign(obj_player.x - x);
}

// 2. ESTADO DE ATAQUE
if (_dist <= attack_dist && can_attack) {
    // Aplicar dano ao jogador (precisaremos criar global.player_hp depois)
    global.player_hp -= damage;
    
    // Iniciar Cooldown
    can_attack = false;
    alarm[0] = attack_cooldown; 
    
    show_debug_message("Inimigo atacou! Dano: " + string(damage));
}

// Se a vida chegar a zero, o inimigo é destruído
if (hp <= 0) {
    show_debug_message("Inimigo destruído!");
    instance_destroy();
}