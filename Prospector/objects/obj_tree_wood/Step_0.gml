// Pega os frames por segundo do jogo para calcular os segundos exatos (ex: 60fps)
var _fps = game_get_speed(gamespeed_fps);

switch (state) {
    // --- 1. CRESCIMENTO ---
    case "growing":
        mask_index = sprite_base; // Garante que a colisão está ativa
        
        if (image_index >= image_number - 1) {
            image_speed = 0; // Para a animação
            image_index = image_number - 1; // Trava no último frame
            state = "idle"; // A árvore agora pode ser cortada
        }
        break;

    // --- 2. PRONTA PARA MINERAR ---
    case "idle":
        // 1. Verifica se o player existe
        if (!instance_exists(obj_player)) break;
        
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
            
            // --- LIMITES DE ALCANCE DA ÁRVORE ---
            var _limite_laterais = 15;   
            var _limite_cima_baixo = 10; 
            
            var _movendo = keyboard_check(ord("W")) || keyboard_check(ord("A")) || keyboard_check(ord("S")) || keyboard_check(ord("D"));
            
            // 3. Se estiver perto, segurando "E" E NÃO estiver tentando se mover
            if (_dist_x <= _limite_laterais && _dist_y <= _limite_cima_baixo && keyboard_check(ord("E")) && !_movendo) {
                
                // Garante que o jogador NÃO esteja com a espada na mão
                if (obj_player.sprite_index != spr_player_sword) {
                    
                    timer_atual += global.mine_speed;
                    
                    // Faz o jogador usar o machado
                    if (obj_player.sprite_index != spr_player_axe) {
                        obj_player.sprite_index = spr_player_axe;
                        obj_player.image_index = 0;
                    }
                    
                    // 4. Quando completar a mineração
                    if (timer_atual >= tempo_mineracao_max) {
                        timer_atual = 0; 
                        global.wood += global.mine_yield;
                        show_debug_message("Madeira coletada!");
                        
                        if (instance_exists(obj_player)) {
                            obj_player.sprite_index = spr_player_still;
                            obj_player.image_index = 0;
                        }
                        
                        // Inicia a animação de queda
                        state = "falling";
                        sprite_index = sprite_fall;
                        image_index = 0;
                        image_speed = 1;
                        mask_index = spr_empty;
                        
                        // INVERTIDO: Faz a árvore cair para o lado OPOSTO do player
                        if (obj_player.x <= x) {
                            image_xscale = -1;  
                        } else {
                            image_xscale = 1;   
                        }
                    }
                } else {
                    // Se o jogador puxou a espada, reseta o progresso da árvore
                    timer_atual = 0;
                }
            } else {
                // Se soltar a tecla, afastar, OU tentar andar, o progresso reseta
                timer_atual = 0; 
            }
        }
        break;

    // --- 3. ANIMAÇÃO DE QUEDA ---
    case "falling":
        // Verifica se a animação de queda chegou ao fim
        if (image_index >= image_number - 1) {
            image_speed = 0;
            state = "waiting"; // Muda para o modo invisível
            
            // Inicia o timer de 5 a 60 segundos
            regrow_timer = irandom_range(5 * _fps, 60 * _fps);
            
            // Remove a máscara de colisão para o player poder andar por cima
            mask_index = spr_empty; 
        }
        break;

    // --- 4. ESPERANDO PARA CRESCER ---
    case "waiting":
        regrow_timer -= 1;
        
        if (regrow_timer <= 0) {
            // Coloca a máscara temporariamente para checar colisão com o player
            mask_index = sprite_base;
            
            if (place_meeting(x, y, obj_player)) {
                // Player está em cima do local! Adiciona 5 a 30 segundos
                regrow_timer = irandom_range(5 * _fps, 30 * _fps);
                mask_index = spr_empty; // Remove a colisão de novo
            } else {
                // O caminho está livre. Nasce a árvore.
                state = "growing";
                sprite_index = sprite_base;
                image_index = 0;
                image_speed = random_range(0.8, 1.2);
                image_xscale = 1; // Reseta o lado que a árvore aponta
            }
        }
        break;
}