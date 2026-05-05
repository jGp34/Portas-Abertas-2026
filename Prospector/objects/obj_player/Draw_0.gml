draw_self(); // Desenha o player

// EFEITO VISUAL DO ATAQUE (Arco com ajuste fino de posição)
if (sprite_index == spr_player_sword && image_index >= 10 && image_index <= 15) {
    
    // Área base da colisão e direção
    var _dist_final = 80 + (global.atk_area - 60); 
    var _raio_final = global.atk_area;
    var _dir = (image_xscale > 0) ? 0 : 180;
    
    // --- MATEMÁTICA DO IMPACTO ---
    var _progresso = (image_index - 10) / 5;
    
    // ==========================================
    // AJUSTES FINOS (Mude esses números se precisar)
    var _y_offset = 20; // Empurra o golpe para baixo (aumente para descer mais)
    var _x_inicio = 8;  // Começa BEM colado no corpo (antes era 20)
    // ==========================================
    
    // LERP: Transição do início ao fim do golpe
    // Inicia no _x_inicio e vai até a distância final levemente recuada (-5)
    var _dist_atual = lerp(_x_inicio, _dist_final - 5, _progresso);
    var _hx = x + lengthdir_x(_dist_atual, _dir);
    var _hy = y + _y_offset; // <--- Aplicamos o rebaixamento aqui!
    
    // O tamanho do arco nasce menor e abre até o máximo
    var _tamanho_atual = lerp(10, _raio_final, _progresso);
    var _alpha = 1 - _progresso;
    
    // --- MATEMÁTICA DO MEIO CÍRCULO (ARCO) ---
    var _ang_inicio = _dir - 80;
    var _ang_fim = _dir + 80;
    var _pontos = 12; 
    var _passo_ang = (_ang_fim - _ang_inicio) / _pontos;
    
    draw_set_alpha(_alpha);
    
    // 1. DESENHA A CAMADA AMARELA (Contorno do vento)
    draw_set_color(c_yellow);
    draw_primitive_begin(pr_linestrip);
    for (var i = 0; i <= _pontos; i++) {
        var _angulo = _ang_inicio + (i * _passo_ang);
        var _px = _hx + lengthdir_x(_tamanho_atual + 3, _angulo);
        var _py = _hy + lengthdir_y(_tamanho_atual + 3, _angulo);
        draw_vertex(_px, _py);
    }
    draw_primitive_end();

    // 2. DESENHA A CAMADA BRANCA (Lâmina principal)
    draw_set_color(c_white);
    draw_primitive_begin(pr_linestrip);
    for (var i = 0; i <= _pontos; i++) {
        var _angulo = _ang_inicio + (i * _passo_ang);
        var _px = _hx + lengthdir_x(_tamanho_atual, _angulo);
        var _py = _hy + lengthdir_y(_tamanho_atual, _angulo);
        draw_vertex(_px, _py);
    }
    draw_primitive_end();
    
    // Reseta as propriedades obrigatoriamente
    draw_set_alpha(1); 
    draw_set_color(c_white);
}