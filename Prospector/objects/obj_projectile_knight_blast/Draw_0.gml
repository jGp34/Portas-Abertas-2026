if (timer <= telegraph_time) {
    // 1. AVISO TELEGRAPH (Piscando Vermelho)
    // Deixei o piscar um pouquinho mais agressivo para o jogador sentir a ameaça
    var _alpha = 0.1 + abs(sin(timer * 0.2)) * 0.3;
    
    draw_set_alpha(_alpha);
    draw_set_color(c_red); 
    draw_circle(x, y, radius, false);
    
    // Contorno para precisão (Mantém um alpha mínimo para a borda nunca sumir)
    draw_set_alpha(0.5 + _alpha);
    draw_circle(x, y, radius, true);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
} 
else {
    // 2. EXPLOSÃO CIRCULAR DINÂMICA (Arco-íris Pulsante)
    
    // O tempo passa rápido, criando o loop contínuo de 0 a 255 do arco-íris
    var _tempo_cor = (current_time * 0.2) mod 255; 
    
    var _qtd_aneis = 8; // Quantidade de "ondas" de energia dentro da área
    var _passo_raio = radius / _qtd_aneis;
    
    // Desenhamos do anel maior (borda) para o menor (centro)
    for (var i = 0; i < _qtd_aneis; i++) {
        
        // O pulso usa "- i" para que cada anel pulse em um momento levemente diferente,
        // criando a ilusão de uma "onda" viajando do centro para a borda!
        var _pulso = sin((timer * 0.25) - i) * (radius * 0.08); 
        
        // Raio atual daquele anel + a distorção orgânica
        var _raio_atual = (radius - (i * _passo_raio)) + _pulso;
        
        // Evita bugar caso a onda diminua o centro abaixo de zero
        if (_raio_atual <= 0) continue; 
        
        // A matiz desliza dependendo da camada e do tempo
        var _matiz = (_tempo_cor + (i * (255 / _qtd_aneis))) mod 255;
        var _cor_dinamica = make_color_hsv(_matiz, 220, 255); 
        
        draw_set_color(_cor_dinamica);
        
        // Degradê do Alpha: A borda fica mais transparente (0.3), e o centro fica forte (0.7)
        var _alpha_anel = 0.3 + (i / _qtd_aneis) * 0.4;
        draw_set_alpha(_alpha_anel);
        
        draw_circle(x, y, _raio_atual, false);
    }
    
    // 3. NÚCLEO BRANCO E BRILHANTE (O Ponto de Impacto)
    draw_set_color(c_white);
    draw_set_alpha(0.6 + sin(timer * 0.6) * 0.4); // O miolo pisca alucinadamente rápido
    
    var _raio_nucleo = radius * 0.15; // O núcleo branco ocupa 15% do tamanho total do círculo
    draw_circle(x, y, _raio_nucleo, false);
    
    // IMPORTANTE: Reseta os padrões globais
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}