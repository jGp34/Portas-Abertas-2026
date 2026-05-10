if (timer <= telegraph_time) {
    // 1. DESENHA O AVISO TELEGRAPH (Piscando Vermelho)
    var _alpha = 0.2 + abs(sin(timer * 0.2)) * 0.3; 
    
    draw_set_alpha(_alpha);
    draw_set_color(c_red);
    // Transformei o aviso num formato circular/oval para combinar com a explosão!
    draw_ellipse(x - raio_width, y - raio_height, x + raio_width, y + raio_height, false);
    
    draw_set_alpha(1.0); // Limpa o alpha para não bugar o resto do jogo
    draw_set_color(c_white);
} 
else {
    // 2. ONDA CIRCULAR PULSANTE E DINÂMICA (Arco-íris)
    
    // O tempo passa rápido, criando um efeito de cor contínuo (vai de 0 a 255 em loop)
    // Isso é o que faz o arco-íris "girar" vivo na tela!
    var _tempo_cor = (current_time * 0.2) mod 255; 
    
    var _qtd_ondas = 6; // Quantidade de auras de energia ao redor do centro
    
    // O loop começa de trás pra frente (da maior para a menor) para não esconder o meio
    for (var i = _qtd_ondas; i > 0; i--) {
        
        // Cria um pulso orgânico (a onda "respira" inflando e desinflando rápido)
        var _pulso = abs(sin((timer * 0.15) + i)); 
        
        // O raio varia dinamicamente em x e y
        var _raio_x = (raio_width / 2) * i * 0.3 + (_pulso * 10);
        var _raio_y = raio_height * 0.9 + (_pulso * 20); 
        
        // A cor muda baseada no tempo e na camada atual (degradê perfeito em HSV)
        var _matiz = (_tempo_cor + (i * (255 / _qtd_ondas))) mod 255;
        // Saturação em 220 para a cor ficar vibrante, mas não "cegar" o jogador
        var _cor_dinamica = make_color_hsv(_matiz, 220, 255); 
        
        draw_set_color(_cor_dinamica);
        // Quanto mais externa for a onda, mais transparente ela fica (suaviza as bordas)
        draw_set_alpha(0.8 - (i * 0.1)); 
        
        // Desenha a onda oval 
        // DICA: Se você quiser uma bola redonda perfeita no chão, troque "draw_ellipse" por:
        // draw_circle(x, y, _raio_x, false);
        draw_ellipse(x - _raio_x, y - _raio_y, x + _raio_x, y + _raio_y, false);
    }
    
    // 3. NÚCLEO DE ENERGIA (Branco Brilhante)
    // Fica no centro de tudo, piscando bem rápido para dar impacto
    draw_set_color(c_white);
    draw_set_alpha(0.8 + sin(timer * 0.5) * 0.2); 
    draw_ellipse(x - (raio_width * 0.3), y - (raio_height * 0.7), x + (raio_width * 0.3), y + (raio_height * 0.7), false);
    
    // IMPORTANTE: Reseta a cor e transparência globais no final!
    draw_set_color(c_white); 
    draw_set_alpha(1.0); 
}