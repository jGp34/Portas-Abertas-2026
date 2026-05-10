timer++;

// FASE 1: Telegraph -> Apenas espera.

// FASE 2: Raio Ativo! (Causa dano)
if (timer > telegraph_time && timer <= telegraph_time + active_time) {
    
    if (!hit_player && instance_exists(obj_player)) {
        // NOVO: Checa colisão tanto para cima (y - raio_height) quanto para baixo (y + raio_height)
        if (collision_rectangle(x - raio_width/2, y - raio_height, x + raio_width/2, y + raio_height, obj_player, false, true)) {
            global.player_hp -= damage;
            hit_player = true;
            show_debug_message("Raio acertou o jogador! Dano: " + string(damage));
        }
    }
} 
// FASE 3: Desaparecer
else if (timer > telegraph_time + active_time) {
    instance_destroy();
}