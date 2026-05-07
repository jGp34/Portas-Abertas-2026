// 1. Verifica se o player existe
if (!instance_exists(obj_player)) exit;

// 2. Só permite interagir se o jogador estiver VIVO
if (global.player_hp > 0) {
    
    // --- DISTÂNCIAS SEPARADAS (Pelas Bordas de Colisão!) ---
    var _dist_x = 0;
    var _dist_y = 0;
    
    // 1. Distância Horizontal (Espaço livre entre a esquerda/direita)
    if (obj_player.bbox_right < bbox_left) {
        _dist_x = bbox_left - obj_player.bbox_right; // Player está na esquerda
    } else if (obj_player.bbox_left > bbox_right) {
        _dist_x = obj_player.bbox_left - bbox_right; // Player está na direita
    }
    
    // 2. Distância Vertical (Espaço livre entre cima/baixo)
    if (obj_player.bbox_bottom < bbox_top) {
        _dist_y = bbox_top - obj_player.bbox_bottom; // Player está em cima
    } else if (obj_player.bbox_top > bbox_bottom) {
        _dist_y = obj_player.bbox_top - bbox_bottom; // Player está embaixo
    }
    
    // --- SEUS LIMITES ---
    // ATENÇÃO: Como agora estamos medindo os "pixels de espaço vazio" 
    // entre vocês e não mais o centro, os números devem ser bem menores!
    var _limite_laterais = 15;   
    var _limite_cima_baixo = 10; 
    
    var _movendo = keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D"));
    
    // 3. Se estiver dentro do limite X, dentro do limite Y, segurando "E" e parado
    if (_dist_x <= _limite_laterais && _dist_y <= _limite_cima_baixo && keyboard_check(ord("E")) && !_movendo) {
        
        // Garante que o jogador NÃO esteja com a espada na mão
        if (obj_player.sprite_index != spr_player_sword) {
            
            timer_atual += global.mine_speed;
            
            // Avisa pro jogador tocar a animação dele (só se já não estiver tocando)
            if (obj_player.sprite_index != spr_player_pickaxe) {
                obj_player.sprite_index = spr_player_pickaxe;
                obj_player.image_index = 0; 
            }
            
            // 4. Quando completar a mineração
            if (timer_atual >= tempo_mineracao_max) {
                timer_atual = 0; 
                
				switch (tipo_minerio) {
				    case "carvao": global.carvao += global.mine_yield; break;
				    case "iron": global.iron += global.mine_yield; break;
				    case "gold": global.gold += global.mine_yield; break;
				}
                
                show_debug_message("Minério coletado: " + tipo_minerio);
            }
        } else {
            // Se o jogador puxou a espada enquanto segurava E, reseta a pedra
            timer_atual = 0;
        }
    } else {
        timer_atual = 0; 
    }
}