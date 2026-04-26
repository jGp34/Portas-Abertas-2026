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
        if (instance_exists(obj_player)) {
            var _dist = point_distance(x, y, obj_player.x, obj_player.y);
            
            if (_dist <= distancia_minima && keyboard_check(ord("E"))) {
                timer_atual += 1; 
                
                // Faz o jogador usar o machado
                if (obj_player.sprite_index != spr_axe) {
                    obj_player.sprite_index = spr_axe;
                    obj_player.image_index = 0;
                }
                
				if (timer_atual >= tempo_mineracao_max) {
				    timer_atual = 0; 
				    global.wood += 1; 
				    show_debug_message("Madeira coletada!");
                    if (instance_exists(obj_player)) {
                        obj_player.sprite_index = spr_still;
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
				        image_xscale = -1;  // Antes era 1. Agora vira para o lado oposto!
				    } else {
				        image_xscale = 1;   // Antes era -1.
				    }
				}
            } else {
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
                image_speed = 1;
                image_xscale = 1; // Reseta o lado que a árvore aponta
            }
        }
        break;
}