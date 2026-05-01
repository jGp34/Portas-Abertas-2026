// 1. Verifica se o player existe e está perto
if (instance_exists(obj_player)) {
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    // NOVIDADE: Verifica se o jogador está pressionando alguma tecla de movimento
    var _movendo = keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D"));
    
    // 2. Se estiver perto, segurando "E" E NÃO estiver tentando se mover
    if (_dist <= distancia_minima && keyboard_check(ord("E")) && !_movendo) {
        timer_atual += 1; // Incrementa o progresso
        
        // --- FAZ O JOGADOR USAR A PICARETA ---
        if (obj_player.sprite_index != spr_player_pickaxe) {
            obj_player.sprite_index = spr_player_pickaxe;
            obj_player.image_index = 0; // Inicia a animação do zero
        }
        
        // 3. Quando completar a mineração
        if (timer_atual >= tempo_mineracao_max) {
            timer_atual = 0; 
            
            // Verifica o TIPO de minério para dar o recurso certo
            switch (tipo_minerio) {
                case "carvao": 
                    global.carvao += 1; 
                    break;
                case "iron": 
                    global.iron += 1; 
                    break;
                case "gold": 
                    global.gold += 1; 
                    break;
            }
            
            show_debug_message("Minério coletado: " + tipo_minerio);
        }
    } else {
        // Se soltar a tecla, afastar, OU tentar andar, o progresso reseta imediatamente!
        timer_atual = 0; 
    }
}