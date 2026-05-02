// 1. Verifica se o player existe
if (!instance_exists(obj_player)) exit;

// 2. Só permite interagir se o jogador estiver VIVO
if (global.player_hp > 0) {
    
    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    var _movendo = keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D"));
    
    // 3. Se estiver perto, segurando "E" E NÃO estiver tentando se mover
    if (_dist <= distancia_minima && keyboard_check(ord("E")) && !_movendo) {
        
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
                    case "carvao": global.carvao += 1; break;
                    case "iron": global.iron += 1; break;
                    case "gold": global.gold += 1; break;
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