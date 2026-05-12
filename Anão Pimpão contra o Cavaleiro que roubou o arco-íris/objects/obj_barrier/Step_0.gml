// Confere se o jogador existe para o jogo não dar erro caso ele morra
if (instance_exists(obj_player)) {
    
    // Calcula a distância da borda do jogador até a borda da barreira
    var _dist = distance_to_object(obj_player);
    
    var _distancia_max = 50; // Distância em pixels onde ela começa a aparecer
    var _distancia_min = 10;  // Distância onde ela fica 100% visível
    
    // Matemática do Fade (Transforma a distância em um valor de Alpha de 0 a 1)
    var _fade = 1 - ((_dist - _distancia_min) / (_distancia_max - _distancia_min));
    
    // Aplica a transparência no objeto (clamp garante que não passe de 1 ou caia de 0)
    image_alpha = clamp(_fade, 0, 1);
}