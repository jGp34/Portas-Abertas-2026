// 1. Só desenha se a barreira estiver minimamente visível
if (image_alpha > 0) {
    
    // Configura a transparência baseada no seu código de aproximação do Step
    draw_set_alpha(image_alpha);
    
    // Escolha a cor da sua magia (c_fuchsia é um rosa/roxo mágico, c_aqua é ciano)
    draw_set_color(c_fuchsia); 
    
    // 2. Desenha a borda principal da barreira
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    
    // 3. O SEGREDO: Criando um efeito pulsante sem spritesheet!
    // Usamos 'sin' (Seno) e o tempo do jogo para o valor subir e descer suavemente
    var _pulso = sin(current_time / 150) * 4; 
    
    // Deixa o meio um pouco mais transparente que as bordas
    draw_set_alpha(image_alpha * 0.4); 
    
    // Desenha vários retângulos internos que ficam pulsando
    draw_rectangle(bbox_left + 2 + _pulso, bbox_top + 2 + _pulso, bbox_right - 2 - _pulso, bbox_bottom - 2 - _pulso, true);
    draw_rectangle(bbox_left + 6 - _pulso, bbox_top + 6 - _pulso, bbox_right - 6 + _pulso, bbox_bottom - 6 + _pulso, true);
    
    // Preenche o fundo com um brilho muito suave
    draw_set_alpha(image_alpha * 0.1);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    
    // 4. RESET OBRIGATÓRIO (para não bugar as cores do resto do jogo)
    draw_set_alpha(1);
    draw_set_color(c_white);
}