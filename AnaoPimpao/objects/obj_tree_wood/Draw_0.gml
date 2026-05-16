// Desenha a árvore apenas se ela não estiver no estado invisível de espera
if (state != "waiting") {
    draw_self(); 
}

// Se estiver no estado pronta e sendo minerada, desenha a barra
if (state == "idle" && timer_atual > 0) {
    var _percentual = (timer_atual / tempo_mineracao_max) * 100;
    draw_healthbar(x - 20, y - 40, x + 20, y - 35, _percentual, c_black, c_gray, c_white, 0, true, true);
}