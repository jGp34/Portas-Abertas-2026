// 2. MOVIMENTO DO PROJÉTIL
x += lengthdir_x(move_spd, direction);
y += lengthdir_y(move_spd, direction);

// 3. COLISÃO COM A PAREDE
if (place_meeting(x, y, obj_barrier)) { 
    instance_destroy();
}

// 4. ACERTOU O JOGADOR
if (place_meeting(x, y, obj_player)) {
    global.player_hp -= damage;
    // Opcional: Adicione um som de impacto específico do Golem aqui
    // var _snd = audio_play_sound(sfx_golem_projectile_hit, 1, false);
    instance_destroy();
}