if (!instance_exists(obj_player)) exit;

// 1. LÓGICA DE MORTE (Atirar no final da animação)
if (hp <= 0) {
    
    // NOVO: Verifica se já está no estado de morte E se a animação chegou no último frame
    if (state == "death" && image_index >= image_number - 1) {
        var _angulos = [45, 135, 225, 315]; // As 4 diagonais
        var _centro_y = y + (sprite_height / 2); // Nasce no meio do corpo
        
        for (var i = 0; i < 4; i++) {
            var _proj = instance_create_layer(x, _centro_y, "Instances", obj_projectile_sahur);
            _proj.damage = damage;             // Repassa o dano do Sahur (50)
            _proj.direction = _angulos[i];     // Aplica a direção diagonal
            _proj.image_angle = _angulos[i];   // Gira a sprite para a diagonal
        }
    }
    
    // Chama a lógica de morte do pai (que vai iniciar a animação e depois destruir o objeto)
    event_inherited(); 
    exit;
}

// 2. LÓGICA DO NASCIMENTO (Trava a IA até acabar)
if (state == "birth") {
    
    // Fica parado enquanto a animação de nascer roda
    if (image_index >= image_number - 1) {
        state = "idle"; // Terminou de nascer! Agora a IA do pai assume.
    } else {
        exit; // Impede que o código continue e rode a perseguição do pai
    }
}

// 3. EXECUTA A INTELIGÊNCIA ARTIFICIAL PADRÃO
// Como setamos o detect_radius para 9999, o pai vai fazer ele caçar o player pra sempre
event_inherited();