draw_self(); // Desenha a sprite da mina

// Se estiver minerando, desenha uma barra de progresso simples em cima da mina
if (timer_atual > 0) {
    var _percentual = (timer_atual / tempo_mineracao_max) * 100;
    draw_healthbar(x - 20, y - 40, x + 20, y - 35, _percentual, c_black, c_gray, c_white, 0, true, true);
}