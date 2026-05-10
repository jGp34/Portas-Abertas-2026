if (timer <= telegraph_time) {
    // 1. DESENHA O AVISO TELEGRAPH (Piscando Vermelho)
    var _alpha = 0.2 + abs(sin(timer * 0.2)) * 0.3; 
    
    draw_set_alpha(_alpha);
    draw_set_color(c_red);
    // Esticado para CIMA e para BAIXO
    draw_rectangle(x - raio_width/2, y - raio_height, x + raio_width/2, y + raio_height, false);
    
    draw_set_alpha(1.0); // Limpa o alpha para não bugar o resto do jogo
    draw_set_color(c_white);
} 
else {
    // 2. DESENHA O RAIO ARCO-ÍRIS VERDADEIRO (7 Listras)
    var _cores = [
        c_red,
        c_orange,
        c_yellow,
        c_green,
        c_blue,
        make_color_rgb(75, 0, 130), // Anil
        make_color_rgb(148, 0, 211) // Violeta
    ];
    
    var _qtd_listras = array_length(_cores);
    var _largura_listra = raio_width / _qtd_listras; 
    var _inicio_x = x - (raio_width / 2);            
    
    // NOVO: Aplica a transparência no raio! (0.7 = 70% opaco, altere se quiser mais claro)
    draw_set_alpha(0.7);
    
    for (var i = 0; i < _qtd_listras; i++) {
        draw_set_color(_cores[i]);
        
        var _x1 = _inicio_x + (i * _largura_listra);
        var _x2 = _x1 + _largura_listra;
        
        // Esticado para CIMA e para BAIXO
        draw_rectangle(_x1, y - raio_height, _x2, y + raio_height, false);
    }
    
    draw_set_color(c_white); 
    draw_set_alpha(1.0); // IMPORTANTE: Reseta a transparência global no final!
}