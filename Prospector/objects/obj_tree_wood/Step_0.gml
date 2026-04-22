if (instance_exists(obj_player)) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    if (_dist <= distancia_minima && keyboard_check(ord("E"))) {
        timer_atual += 1; 
        
        // --- FAZ O JOGADOR USAR O MACHADO ---
        if (obj_player.sprite_index != spr_axe) {
            obj_player.sprite_index = spr_axe;
            obj_player.image_index = 0;
        }
        
        if (timer_atual >= tempo_mineracao_max) {
            timer_atual = 0; 
            global.wood += 1; 
            show_debug_message("Madeira coletada!");
        }
    } else {
        timer_atual = 0; 
    }
}