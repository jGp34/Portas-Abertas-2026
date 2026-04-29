// 1. Verifica se o player existe e está perto
if (instance_exists(obj_player)) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    // 2. Se estiver perto e segurando a tecla "E"
    if (_dist <= distancia_minima && keyboard_check(ord("E"))) {
        timer_atual += 1; // Incrementa o progresso
        
        // --- FAZ O JOGADOR USAR A PICARETA ---
        if (obj_player.sprite_index != spr_pickaxe) {
            obj_player.sprite_index = spr_pickaxe;
            obj_player.image_index = 0; // Inicia a animação do zero
        }
        
        // 3. Quando completar a mineração
        if (timer_atual >= tempo_mineracao_max) {
            timer_atual = 0; 
            global.gold += 1; // (Altere de acordo com o minério)
            show_debug_message("Minério coletado!");
        }
    } else {
        // Se soltar a tecla ou afastar, o progresso reseta
        timer_atual = 0; 
    }
}