draw_set_color(c_white);

draw_text(50, 30, "=== O FIM É APENAS O COMEÇO ===");
draw_text(50, 60, "Seus Recursos: " + string(global.wood) + " Mad | " + string(global.iron) + " Fer | " + string(global.carvao) + " Car | " + string(global.gold) + " Our");

// Botões do Teclado para simplificar a interface
draw_text(50, 120, "[1] +Vida Max (Custa " + string(custo_vida) + " Madeira) | Atual: " + string(global.max_hp));
draw_text(50, 160, "[2] +Dano (Custa " + string(custo_dano) + " Ferro) | Atual: " + string(global.player_damage));
draw_text(50, 200, "[3] +Vel. Minerar (Custa " + string(custo_vel) + " Carvão) | Atual: " + string(global.mine_speed));
draw_text(50, 240, "[4] +Drop Extra (Custa " + string(custo_yield) + " Ouro) | Atual: " + string(global.mine_yield));

draw_set_color(c_yellow);
draw_text(50, 320, "Pressione [ESPAÇO] para Ressuscitar");
draw_set_color(c_white);