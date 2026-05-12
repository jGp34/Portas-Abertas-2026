depth = -bbox_bottom;

// MOVIMENTO DO PROJÉTIL
x += lengthdir_x(move_spd, direction);
y += lengthdir_y(move_spd, direction);

// COLISÃO COM A PAREDE
if (place_meeting(x, y, obj_barrier)) { 
    instance_destroy();
}

// ACERTOU O JOGADOR
if (place_meeting(x, y, obj_player)) {
    global.player_hp -= damage;
    // audio_play_sound(sfx_sahur_hit, 1, false); // Som futuramente
    instance_destroy();
}