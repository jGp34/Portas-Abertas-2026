// 1. DESTRUÍDO PELA ESPADA (O jogador tira HP dele)
if (hp <= 0) {
    // Aqui você pode colocar uma partícula ou som de osso quebrando!
    instance_destroy();
    exit;
	
}

// 2. MOVIMENTO DO PROJÉTIL
x += lengthdir_x(move_spd, direction);
y += lengthdir_y(move_spd, direction);

// 3. COLISÃO COM A PAREDE (Destrói o tiro)
if (place_meeting(x, y, obj_barrier)) { // (Se usar obj_colision, mude aqui)
    instance_destroy();
}

// 4. ACERTOU O JOGADOR
if (place_meeting(x, y, obj_player)) {
    global.player_hp -= damage;
    var _snd = audio_play_sound(sfx_projectile_hit, 1, false);
    instance_destroy();
}