if (timer <= telegraph_time) {
    // TELEGRAPH: Mantive o visual original piscando (ajustei para vermelho para alertar perigo)
    var _alpha = 0.1 + abs(sin(timer * 0.2)) * 0.2;
    draw_set_alpha(_alpha);
    draw_set_color(c_red); // Mudei para vermelho para indicar área de perigo telegrafada
    draw_circle(x, y, radius, false);
    
    // Contorno para precisão
    draw_set_alpha(0.5);
    draw_circle(x, y, radius, true);
} 
else {
    // ATIVO: Arco-íris circular concêntrico transparente (de dentro pra fora)
    draw_set_alpha(0.6); // Transparência solicitada
    
    // Define as cores
    var _cores = [
        c_red,                        // Fora
        c_orange,
        c_yellow,
        c_green,
        c_blue,
        make_color_rgb(75, 0, 130),   // Anil
        make_color_rgb(148, 0, 211)   // Violeta (Dentro)
    ];
    
    var _num_cores = array_length(_cores);
    // Divide o raio para que cada cor tenha a mesma espessura de anel
    var _passo_raio = radius / _num_cores; 

    // Desenha do maior para o menor (o menor fica por cima no centro)
    // Para desenhar de dentro para fora visivelmente usando preenchimento,
    // desenhamos a cor externa primeiro, e a interna por último cobrindo o centro.
    for (var i = 0; i < _num_cores; i++) {
        draw_set_color(_cores[i]);
        // O raio diminui a cada iteração
        var _raio_atual = radius - (i * _passo_raio);
        draw_circle(x, y, _raio_atual, false);
    }
}

// Reseta padrões
draw_set_alpha(1.0);
draw_set_color(c_white);