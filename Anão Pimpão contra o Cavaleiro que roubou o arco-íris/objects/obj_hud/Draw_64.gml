draw_set_font(fnt_text);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Garante que a animação não quebre se o Draw rodar antes do Step
if (!variable_instance_exists(id, "hp_smooth")) hp_smooth = global.player_hp;

// ==========================================
// 1. BARRA DE VIDA (Top Left)
// ==========================================
var _bar_x = 20; 
var _bar_y = 20;
var _bar_w = 300; // Largura total da barra (pode aumentar se quiser)
var _bar_h = 24;  // Grossura da barra

var _hp_percent = global.player_hp / global.max_hp;
var _hp_smooth_percent = hp_smooth / global.max_hp;

// A. Borda Externa Grossa (Truque do bloco maior opaco)
draw_set_color(make_color_rgb(10, 10, 15)); // Quase preto
draw_roundrect_ext(_bar_x - 4, _bar_y - 4, _bar_x + _bar_w + 4, _bar_y + _bar_h + 4, 12, 12, false);

// B. Fundo da Barra (Trilho vazio)
draw_set_color(make_color_rgb(40, 20, 20)); // Vermelho bem escuro
draw_roundrect_ext(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, 8, 8, false);

// C. Barra Branca/Amarela (O rastro do dano caindo devagar)
var _smooth_width = _bar_w * _hp_smooth_percent;
if (_smooth_width > 0) {
    draw_set_color(c_white);
    draw_roundrect_ext(_bar_x, _bar_y, _bar_x + _smooth_width, _bar_y + _bar_h, 8, 8, false);
}

// D. Barra de Vida Real (Muda de cor conforme a vida cai!)
var _hp_color = merge_color(c_red, c_lime, _hp_percent); // Verde quando cheio, vermelho quando vazio
var _real_width = _bar_w * _hp_percent;
if (_real_width > 0) {
    draw_set_color(_hp_color);
    draw_roundrect_ext(_bar_x, _bar_y, _bar_x + _real_width, _bar_y + _bar_h, 8, 8, false);
}

// E. Texto de HP centralizado e com sombra
draw_set_halign(fa_center); draw_set_valign(fa_middle);
var _txt_x = _bar_x + (_bar_w / 2);
var _txt_y = _bar_y + (_bar_h / 2);

// Sombra
draw_set_color(c_black);
draw_text(_txt_x + 1, _txt_y + 1, string(global.player_hp) + " / " + string(global.max_hp));
// Texto Principal
draw_set_color(c_white);
draw_text(_txt_x, _txt_y, string(global.player_hp) + " / " + string(global.max_hp));

draw_set_halign(fa_left); draw_set_valign(fa_top); // Reseta

// ==========================================
// 2. STATUS DO JOGADOR (HUD Expansível com TAB)
// ==========================================
var _stat_y = _bar_y + _bar_h + 10;

// Se o jogador estiver SEGURANDO a tecla TAB
if (keyboard_check(vk_tab)) {
    
    var _panel_w = 260;
    
    // Calcula a altura do painel dinamicamente dependendo do que ele tem!
    var _panel_h = 230; // Altura base (Atributos do Jogador)
    if (global.fairy_unlocked == 1) _panel_h += 90;
    if (global.burguer_unlocked == 1) _panel_h += 80;
    
    // Fundo translúcido do painel
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(15, 15, 20));
    draw_roundrect_ext(_bar_x - 4, _stat_y, _bar_x + _panel_w, _stat_y + _panel_h, 8, 8, false);
    
    // Borda do painel
    draw_set_color(c_dkgray);
    draw_roundrect_ext(_bar_x - 4, _stat_y, _bar_x + _panel_w, _stat_y + _panel_h, 8, 8, true);
    draw_set_alpha(1);
    
    // Título do painel
    draw_set_color(make_color_rgb(255, 215, 0)); // Dourado
    draw_text(_bar_x + 10, _stat_y + 10, "ATRIBUTOS");
    
    // Lista de Atributos (Usando _sy para pular as linhas automaticamente)
    draw_set_color(make_color_rgb(220, 220, 220)); // Branco levemente acinzentado
    var _sy = _stat_y + 40;
    var _esp = 22; // Espaçamento entre as linhas
    
    draw_text(_bar_x + 10, _sy, "Dano Base: " + string(global.player_damage)); _sy += _esp;
    draw_text(_bar_x + 10, _sy, "Vel. de Ataque: " + string(global.atk_speed)); _sy += _esp;
    draw_text(_bar_x + 10, _sy, "Área do Golpe: " + string(global.atk_area)); _sy += _esp;
    
    // Destaca os acertos críticos
    //draw_set_color(make_color_rgb(200, 150, 255));
    draw_text(_bar_x + 10, _sy, "Chance de Crítico: " + string(global.crit_chance) + "%"); _sy += _esp;
    draw_text(_bar_x + 10, _sy, "Mult. Crítico: " + string(global.crit_dano) + "x"); _sy += _esp;
    
    draw_set_color(make_color_rgb(220, 220, 220));
    draw_text(_bar_x + 10, _sy, "Vel. de Movimento: " + string(global.player_move_speed)); _sy += _esp;
    draw_text(_bar_x + 10, _sy, "Vel. da Picareta: " + string(global.mine_speed) + "x"); _sy += _esp;
    draw_text(_bar_x + 10, _sy, "Drop Extra: " + string(global.mine_yield)); _sy += _esp;
    
    // ==========================================
    // STATUS DOS ALIADOS (Aparecem só se desbloqueados)
    // ==========================================
    
    if (global.fairy_unlocked == 1) {
        _sy += 5; // Dá um respiro antes do novo título
        draw_set_color(c_fuchsia); 
        draw_text(_bar_x + 10, _sy, "FADA"); _sy += _esp;
        
        draw_set_color(make_color_rgb(220, 220, 220));
        draw_text(_bar_x + 10, _sy, "Dano: " + string(global.fairy_damage)); _sy += _esp;
        draw_text(_bar_x + 10, _sy, "Vel. Ataque: " + string(global.fairy_atk_speed) + " frames"); _sy += _esp;
        draw_text(_bar_x + 10, _sy, "Visão: " + string(global.fairy_vision) + " px"); _sy += _esp;
    }

    if (global.burguer_unlocked == 1) {
        _sy += 5; 
        draw_set_color(c_orange); 
        draw_text(_bar_x + 10, _sy, "HAMBÚRGUER"); _sy += _esp;
        
        draw_set_color(make_color_rgb(220, 220, 220));
        draw_text(_bar_x + 10, _sy, "Cura: " + string(global.burguer_heal_amount) + " HP"); _sy += _esp;
        draw_text(_bar_x + 10, _sy, "Vel. Cura: " + string(global.burguer_heal_speed) + " frames"); _sy += _esp;
    }
    
} else {
    // Se NÃO estiver segurando TAB, mostra apenas a dica
    draw_set_alpha(0.7);
    draw_set_color(c_white);
    draw_text(_bar_x, _stat_y, "Segure [TAB] para ver os Atributos");
    draw_set_alpha(1);
}


// ==========================================
// 3. INVENTÁRIO DE RECURSOS (Canto Superior Direito)
// ==========================================
var _inv_w = 160;
var _inv_h = 175;
var _inv_x = _gui_w - _inv_w - 20; // 20px de margem da direita
var _inv_y = 20;

// Fundo do Inventário
draw_set_alpha(0.8);
draw_set_color(make_color_rgb(15, 15, 20));
draw_roundrect_ext(_inv_x, _inv_y, _inv_x + _inv_w, _inv_y + _inv_h, 12, 12, false);

// Borda elegante (mesmo truque do menu de upgrades)
draw_set_color(c_dkgray);
draw_roundrect_ext(_inv_x, _inv_y, _inv_x + _inv_w, _inv_y + _inv_h, 12, 12, true);
draw_roundrect_ext(_inv_x - 1, _inv_y - 1, _inv_x + _inv_w + 1, _inv_y + _inv_h + 1, 13, 13, true);
draw_set_alpha(1);

// Título do Bolso
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_inv_x + (_inv_w / 2), _inv_y + 10, "INVENTÁRIO");
draw_set_halign(fa_left);

// Lista de Recursos (Alinhados com espaçamento perfeito)
var _ry = _inv_y + 40;
var _espaco = 25;

draw_set_color(c_orange); draw_text(_inv_x + 15, _ry, "Mad: " + string(global.wood)); _ry += _espaco;
draw_set_color(c_ltgray); draw_text(_inv_x + 15, _ry, "Fer: " + string(global.iron)); _ry += _espaco;
draw_set_color(make_color_rgb(150, 150, 150)); draw_text(_inv_x + 15, _ry, "Car: " + string(global.carvao)); _ry += _espaco;
draw_set_color(c_yellow); draw_text(_inv_x + 15, _ry, "Our: " + string(global.gold)); _ry += _espaco;
draw_set_color(c_aqua);   draw_text(_inv_x + 15, _ry, "Alm: " + string(global.souls));

// Reseta tudo pro resto do jogo não bugar
draw_set_color(c_white);