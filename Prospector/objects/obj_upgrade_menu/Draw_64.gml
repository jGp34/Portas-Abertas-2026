draw_set_font(fnt_text);

// ==========================================
// CABEÇALHO E RECURSOS (Sempre Visíveis)
// ==========================================
draw_set_color(c_white);
draw_text(50, 30, "=== O FIM É APENAS O COMEÇO ===");

// Inventário Colorido
var _xx = 50;
var _yy = 60;
draw_set_color(c_white);  draw_text(_xx, _yy, "Recursos: ");      _xx += string_width("Recursos: ");
draw_set_color(c_orange); draw_text(_xx, _yy, string(global.wood) + " Mad | "); _xx += string_width(string(global.wood) + " Mad | ");
draw_set_color(c_ltgray); draw_text(_xx, _yy, string(global.iron) + " Fer | "); _xx += string_width(string(global.iron) + " Fer | ");
draw_set_color(c_dkgray); draw_text(_xx, _yy, string(global.carvao) + " Car | ");_xx += string_width(string(global.carvao) + " Car | ");
draw_set_color(c_yellow); draw_text(_xx, _yy, string(global.gold) + " Our | "); _xx += string_width(string(global.gold) + " Our | ");
draw_set_color(c_aqua);   draw_text(_xx, _yy, string(global.souls) + " Alm");

// Instrução de mudar de aba
draw_set_color(c_yellow);
if (menu_page == 0) {
    draw_text(50, 100, "[ Pressione Q para ver MAGIA & ALIADOS ] --- Página: JOGADOR (1/2)");
} else {
    draw_text(50, 100, "[ Pressione Q para ver STATUS DO JOGADOR ] --- Página: MAGIA (2/2)");
}

// ==========================================
// PÁGINA 0: JOGADOR
// ==========================================
if (menu_page == 0) {
    draw_set_color(c_lime);
    draw_text(50, 150, "[1] +Vida Max (Custa " + string(custo_vida) + " Madeira) | Atual: " + string(global.max_hp));
    draw_text(50, 190, "[6] +Vel. Movimento (Custa " + string(custo_move_speed) + " Carvão) | Atual: " + string(global.player_move_speed));

    draw_set_color(c_orange);
    draw_text(50, 230, "[3] +Vel. Minerar (Custa " + string(custo_vel) + " Carvão) | Atual: " + string(global.mine_speed));
    draw_text(50, 270, "[4] +Drop Extra (Custa " + string(custo_yield) + " Ouro) | Atual: " + string(global.mine_yield));

    draw_set_color(c_red);
    draw_text(50, 310, "[2] +Dano (Custa " + string(custo_dano) + " Ferro) | Atual: " + string(global.player_damage));
    draw_text(50, 350, "[5] +Vel. Ataque (Custa " + string(custo_atk_speed) + " Ouro) | Atual: " + string(global.atk_speed));
    draw_text(50, 390, "[7] +Área Ataque (Custa " + string(custo_atk_area) + " Ferro) | Atual: " + string(global.atk_area));

    draw_set_color(make_color_rgb(180, 130, 255)); // Roxo
    draw_text(50, 430, "[8] +Dano Crítico (Custa " + string(custo_critico) + " Souls) | Atual: " + string(global.crit_chance) + "%");
}


// ==========================================
// PÁGINA 1: MAGIA E ALIADOS
// ==========================================
else if (menu_page == 1) {
    
    // --- SEÇÃO DA FADA ---
    draw_set_color(c_fuchsia);
    draw_text(50, 150, "=== FADA ATIRADORA ===");

    if (global.fairy_unlocked == 0) {
        draw_set_color(c_aqua);
        draw_text(50, 200, "[1] DESBLOQUEAR Fada (Custa " + string(custo_fada_unlock) + " Souls)");
    } else {
        draw_set_color(c_aqua);
        draw_text(50, 200, "[1] +Dano Fada (Custa " + string(custo_fada_dano) + " Ouro) | Atual: " + string(global.fairy_damage));
        draw_text(50, 240, "[2] +Vel. Atk Fada (Custa " + string(custo_fada_vel) + " Ouro) | Atual: " + string(global.fairy_atk_speed) + " frames");
        draw_text(50, 280, "[3] +Range Visão (Custa " + string(custo_fada_range) + " Ferro) | Atual: " + string(global.fairy_vision) + "px");
    }

    // --- SEÇÃO DO HAMBÚRGUER ---
    draw_set_color(c_orange);
    draw_text(50, 340, "=== HAMBÚRGUER CURANDEIRO ===");

    if (global.burguer_unlocked == 0) {
        draw_set_color(c_lime); // Verde para cura
        draw_text(50, 390, "[4] DESBLOQUEAR Hambúrguer (Custa " + string(custo_burguer_unlock) + " Souls)");
    } else {
        draw_set_color(c_lime);
        draw_text(50, 390, "[4] +Cura Hambúrguer (Custa " + string(custo_burguer_heal) + " Ouro) | Atual: " + string(global.burguer_heal_amount) + " HP");
        draw_text(50, 430, "[5] +Vel. Cura Hambúrguer (Custa " + string(custo_burguer_speed) + " Ferro) | Atual: " + string(global.burguer_heal_speed) + " frames");
    }
}
// ==========================================
// RODAPÉ / RESSUSCITAR (Sempre visível)
// ==========================================
draw_set_color(c_yellow);
draw_text(50, 600, "Pressione [ESPAÇO] para Ressuscitar e Voltar para a Mina");
draw_set_color(c_white);