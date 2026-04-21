// 1. Verifica se o player existe e está perto
if (instance_exists(obj_player)) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    // 2. Se estiver perto e segurando a tecla "E"
    if (_dist <= distancia_minima && keyboard_check(ord("E"))) {
        timer_atual += 1; // Incrementa o progresso
        
        // 3. Quando completar a mineração
        if (timer_atual >= tempo_mineracao_max) {
            timer_atual = 0; // Reseta o timer para minerar de novo
            global.gold += 1; // Função ou código para adicionar ao inventário
            show_debug_message("Ouro coletado: " + string(global.gold));
        }
    } else {
        // Se soltar a tecla ou afastar, o progresso reseta
        timer_atual = 0; 
    }
}