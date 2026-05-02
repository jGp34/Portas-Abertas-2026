//draw_set_color(c_white);
//draw_text(20, 20, "Madeira: " + string(global.wood));
//draw_text(20, 40, "Carvao: " + string(global.carvao));
//draw_text(20, 60, "Ferro: " + string(global.iron));
//draw_text(20, 80, "Ouro: " + string(global.gold));


draw_set_font(fnt_text);
// Define a cor e o alinhamento padrão para evitar bugs visuais
draw_set_color(c_white);
draw_set_halign(fa_left);

// Variáveis para controlar a posição na tela (Margem X e Y)
var _xx = 20; 
var _yy = 20;
var _espacamento = 25; // Distância entre cada linha de texto

// 1. VIDA (Vamos colocar em vermelho para destacar)
draw_set_color(c_red);
draw_text(_xx, _yy, "HP: " + string(global.player_hp) + " / " + string(global.max_hp));

// Volta para o branco para os status normais
draw_set_color(c_white);

// 2. STATUS DO JOGADOR
draw_text(_xx, _yy + _espacamento * 1, "Dano de Ataque: " + string(global.player_damage));
draw_text(_xx, _yy + _espacamento * 2, "Vel. de Mineração: " + string(global.mine_speed) + "x");
draw_text(_xx, _yy + _espacamento * 3, "Minérios por hit: " + string(global.mine_yield));

// 3. RECURSOS NO BOLSO (Opcional, mas muito útil para um Roguelite!)
var _yy_recursos = _yy + _espacamento * 5; // Pula um espaço extra
draw_set_color(c_yellow);
draw_text(_xx, _yy_recursos, "Inventário:");
draw_set_color(c_white);
draw_text(_xx, _yy_recursos + _espacamento * 1, "Madeira: " + string(global.wood));
draw_text(_xx, _yy_recursos + _espacamento * 2, "Ferro: " + string(global.iron));
draw_text(_xx, _yy_recursos + _espacamento * 3, "Carvão: " + string(global.carvao));
draw_text(_xx, _yy_recursos + _espacamento * 4, "Ouro: " + string(global.gold));