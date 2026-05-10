// Desenha o próprio cavaleiro primeiro
draw_self();

// EFEITO VISUAL DO ATAQUE (Slash Extravagante - Lâmina de Energia)
if (sprite_index == spr_knight_slash && image_index >= (image_number * 0.25)) {
    
    var _frame_impacto = image_number * 0.25;
    var _frames_restantes = image_number - _frame_impacto;
    var _progresso = clamp((image_index - _frame_impacto) / _frames_restantes, 0, 1);
    
    // Deixei a área do corte ainda maior e mais agressiva
    var _dist_final = 70; 
    var _raio_final = 90; 
    var _dir = (image_xscale > 0) ? 0 : 180;
    
    var _y_offset = 40; 
    var _x_inicio = 15; 
    
    var _dist_atual = lerp(_x_inicio, _dist_final, _progresso);
    var _hx = x + lengthdir_x(_dist_atual, _dir);
    var _hy = y + _y_offset; 
    
    var _tamanho_atual = lerp(20, _raio_final, _progresso);
    var _alpha_base = 1 - _progresso; // Vai sumindo no final do golpe
    
    var _ang_inicio = _dir - 100; // Arco bem aberto
    var _ang_fim = _dir + 100;
    var _pontos = 24; // Mais pontos = energia mais detalhada e fluida
    var _passo_ang = (_ang_fim - _ang_inicio) / _pontos;
    
    // O tempo passa rápido para as cores girarem e a energia "tremer"
    var _tempo_cor = (current_time * 0.3) mod 255;
    
    // ==========================================
    // DESENHANDO A ENERGIA EM 3 CAMADAS (Fundo, Meio e Núcleo)
    // ==========================================
    var _camadas = 3;
    
    for (var c = 0; c < _camadas; c++) {
        
        // Quanto mais externa a camada, mais grossa ela é.
        // Camada 0: Aura gigante (24px) | Camada 1: Aura média (16px) | Camada 2: Núcleo (8px)
        var _grossura = (3 - c) * 8; 
        
        // A transparência muda. A aura de fora é fraca, o núcleo é forte.
        var _alpha_camada = _alpha_base * (0.3 + (c * 0.35));
        
        // pr_trianglestrip cria formas preenchidas 3D-like ligando os pontos em zigue-zague
        draw_primitive_begin(pr_trianglestrip);
        
        for (var i = 0; i <= _pontos; i++) {
            var _angulo = _ang_inicio + (i * _passo_ang);
            
            // ---> A MÁGICA DA ENERGIA CAÓTICA <---
            // Faz a borda da espada "vibrar" e parecer chama/eletricidade!
            // O núcleo (c=2) não vibra, apenas a aura ao redor.
            var _caos = sin((current_time * 0.02) + (i * 2)) * ((3 - c) * 6);
            
            var _raio_interno = _tamanho_atual - _grossura;
            if (_raio_interno < 0) _raio_interno = 0; // Impede a textura de bugar
            
            var _raio_externo = _tamanho_atual + _grossura + _caos;
            
            var _px_in = _hx + lengthdir_x(_raio_interno, _angulo);
            var _py_in = _hy + lengthdir_y(_raio_interno, _angulo);
            
            var _px_out = _hx + lengthdir_x(_raio_externo, _angulo);
            var _py_out = _hy + lengthdir_y(_raio_externo, _angulo);
            
            if (c == 2) {
                // A ÚLTIMA CAMADA É O NÚCLEO BRANCO DA LÂMINA
                draw_vertex_color(_px_in, _py_in, c_white, 0); // Dentro é invisível
                draw_vertex_color(_px_out, _py_out, c_white, _alpha_camada); // Borda forte
            } else {
                // AS CAMADAS EXTERNAS SÃO O ARCO-ÍRIS GIRATÓRIO
                var _matiz = (_tempo_cor + (i * (255 / _pontos)) + (c * 50)) mod 255;
                var _cor_energia = make_color_hsv(_matiz, 220, 255);
                
                // Desenhamos 2 pontos por loop para montar a "parede" de energia
                draw_vertex_color(_px_in, _py_in, _cor_energia, 0); // Ponto de baixo (fade out pro meio)
                draw_vertex_color(_px_out, _py_out, _cor_energia, _alpha_camada); // Ponto de cima (cor forte)
            }
        }
        draw_primitive_end();
    }
    
    // Reseta padrões
    draw_set_alpha(1); 
    draw_set_color(c_white);
}