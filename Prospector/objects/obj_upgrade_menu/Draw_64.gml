draw_set_font(fnt_text);
draw_set_color(c_white);

draw_text(50, 30, "=== O FIM É APENAS O COMEÇO ===");

// Tudo na mesma linha, padronizado!
draw_text(50, 60, "Recursos: " + string(global.wood) + " Mad | " + string(global.iron) + " Fer | " + string(global.carvao) + " Car | " + string(global.gold) + " Our | " + string(global.souls) + " Alm");

// Botões
draw_text(50, 120, "[1] +Vida Max (Custa " + string(custo_vida) + " Madeira) | Atual: " + string(global.max_hp));
draw_text(50, 160, "[2] +Dano (Custa " + string(custo_dano) + " Ferro) | Atual: " + string(global.player_damage));
draw_text(50, 200, "[3] +Vel. Minerar (Custa " + string(custo_vel) + " Carvão) | Atual: " + string(global.mine_speed));
draw_text(50, 240, "[4] +Drop Extra (Custa " + string(custo_yield) + " Ouro) | Atual: " + string(global.mine_yield));

// Novos Botões
draw_text(50, 280, "[5] +Vel. Ataque (Custa " + string(custo_atk_speed) + " Ouro) | Atual: " + string(global.atk_speed));
draw_text(50, 320, "[6] +Vel. Movimento (Custa " + string(custo_move_speed) + " Carvão) | Atual: " + string(global.player_move_speed));
draw_text(50, 360, "[7] +Área Ataque (Custa " + string(custo_atk_area) + " Ferro) | Atual: " + string(global.atk_area));

// Botão 8
draw_text(50, 400, "[8] +Dano Crítico (Custa " + string(custo_critico) + " Souls) | Atual: " + string(global.crit_chance) + "%");

draw_set_color(c_yellow);
draw_text(50, 460, "Pressione [ESPAÇO] para Ressuscitar");
draw_set_color(c_white);