timer++;

// Fase de Dano
if (timer > telegraph_time && timer <= telegraph_time + active_time) {
    if (!hit_player && instance_exists(obj_player)) {
        // Checa se o jogador está dentro do círculo
        if (point_distance(x, y, obj_player.x, obj_player.y) < radius) {
            global.player_hp -= damage;
            hit_player = true;
            show_debug_message("Explosão Circular acertou!");
        }
    }
} 
else if (timer > telegraph_time + active_time) {
    instance_destroy();
}