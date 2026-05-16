draw_set_font(fnt_text);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_sprite_stretched(spr_fundo_santuario, 0, 0, 0, _gui_w, _gui_h);

// ========================================================
// TRAVA DE SEGURANÇA (Impede a tela de ficar preta/vazia)
// ========================================================
if (!variable_global_exists("boss_morto")) {
    global.boss_morto = false;
}

// ==========================================
// FUNÇÃO LOCAL: DESENHAR CARTA DE UPGRADE
// ==========================================
var _desenhar_carta = function(_cx, _cy, _tecla, _titulo, _val_atual, _custo_txt, _custo_cor, _pode_comprar, _limite_atingido) {
    var _cw = 260; // Largura da carta
    var _ch = 110; // Altura da carta
    var _espessura = 3; // O quão grossa você quer a borda
    
    // ---> AQUI ESTÁ A LÓGICA QUE FALTAVA NA SUA FUNÇÃO! <---
    // Se atingiu o limite, força a carta a bloquear visualmente
    if (_limite_atingido) {
        _pode_comprar = false;
        _custo_txt = "LIMITE ALCANÇADO!";
        _custo_cor = make_color_rgb(255, 80, 80); // Vermelho
    }
    
    // ========================================================
    // 1. DESENHA A BORDA SÓLIDA PRIMEIRO
    // ========================================================
    if (_pode_comprar) {
        var _glow = abs(sin(tempo_menu * 0.05)) * 0.4; 
        draw_set_alpha(0.6 + _glow);
        draw_set_color(make_color_rgb(255, 215, 0)); // Dourado
        draw_roundrect_ext(_cx - _espessura, _cy - _espessura, _cx + _cw + _espessura, _cy + _ch + _espessura, 14, 14, false);
        draw_set_alpha(1);
    } else {
        draw_set_color(make_color_rgb(80, 20, 20)); // Vermelho bloqueado
        draw_roundrect_ext(_cx - _espessura, _cy - _espessura, _cx + _cw + _espessura, _cy + _ch + _espessura, 14, 14, false);
    }
    
    // ========================================================
    // 2. DESENHA O FUNDO DA CARTA POR CIMA
    // ========================================================
    draw_set_color(make_color_rgb(15, 15, 20)); // Fundo cinza escuro opaco
    draw_roundrect_ext(_cx, _cy, _cx + _cw, _cy + _ch, 12, 12, false);
    
    // --------------------------------------------------------
    // RESTO DO CÓDIGO (Badge e Textos)
    // --------------------------------------------------------
    
    // Distintivo (Badge) do Teclado
    draw_set_color(c_white);
    draw_roundrect_ext(_cx + 10, _cy - 10, _cx + 40, _cy + 20, 5, 5, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(_cx + 25, _cy + 5, _tecla);
    
    // Textos Internos
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(_cx + _cw/2, _cy + 15, _titulo);
    
    draw_set_color(c_ltgray);
    if (_limite_atingido) {
        draw_text(_cx + _cw/2, _cy + 45, "Atual: MÁXIMO");
    } else {
        draw_text(_cx + _cw/2, _cy + 45, "Atual: " + string(_val_atual));
    }
    
    draw_set_color(_custo_cor);
    draw_text(_cx + _cw/2, _cy + 75, string(_custo_txt));
    
    // Reseta alinhamentos
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}
// ==========================================
// DESENHAR BARRA DE RECURSOS NO TOPO (CENTRALIZADA)
// ==========================================
draw_set_alpha(0.9);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, 50, false);
draw_set_alpha(1);

// 1. Prepara os textos exatos que vão aparecer
var _str_inv  = "INVENTÁRIO:   ";
var _str_wood = "Mad: " + string(global.wood) + "   ";
var _str_iron = "Fer: " + string(global.iron) + "   ";
var _str_coal = "Car: " + string(global.carvao) + "   ";
var _str_gold = "Our: " + string(global.gold) + "   ";
var _str_soul = "Alm: " + string(global.souls);

// 2. Soma o tamanho de todos os textos no GameMaker
var _tamanho_total = string_width(_str_inv) + string_width(_str_wood) + string_width(_str_iron) + string_width(_str_coal) + string_width(_str_gold) + string_width(_str_soul);

// 3. Acha o X exato para o primeiro texto começar e ficar tudo no meio da tela
var _xx = (_gui_w / 2) - (_tamanho_total / 2);
var _yy = 15;

// 4. Desenha e avança o X de forma perfeita
draw_set_color(c_white);  draw_text(_xx, _yy, _str_inv);  _xx += string_width(_str_inv);
draw_set_color(c_orange); draw_text(_xx, _yy, _str_wood); _xx += string_width(_str_wood);
draw_set_color(c_ltgray); draw_text(_xx, _yy, _str_iron); _xx += string_width(_str_iron);
draw_set_color(c_dkgray); draw_text(_xx, _yy, _str_coal); _xx += string_width(_str_coal);
draw_set_color(c_yellow); draw_text(_xx, _yy, _str_gold); _xx += string_width(_str_gold);
draw_set_color(c_aqua);   draw_text(_xx, _yy, _str_soul);

// ==========================================
// TÍTULO DA ABA / INSTRUÇÕES
// ==========================================
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_gui_w / 2, 80, "SANTUÁRIO DE UPGRADES"); // Mantido exato

draw_set_color(c_yellow);
var _texto_aba = (menu_page == 0) ? "[Q] Trocar para MAGIA & ALIADOS" : "[Q] Trocar para STATUS DO JOGADOR";
draw_text(_gui_w / 2, 110, _texto_aba);
draw_set_halign(fa_left);

// ==========================================
// SISTEMA DE GRID (Posicionamento das Cartas)
// ==========================================
var _grid_start_x = (_gui_w / 2) - ((260 * 3) + (20 * 2)) / 2; 
var _grid_start_y = 170;
var _space_x = 280; 
var _space_y = 130; 

// ==========================================
// PÁGINA 0: JOGADOR
// ==========================================
if (menu_page == 0) {
    // Checagens com os valores EXATOS do seu Evento Step
    var _vida_max      = (global.max_hp >= 220 && !global.boss_morto);
    var _dano_max      = (global.player_damage >= 100 && !global.boss_morto);
    var _atk_spd_max   = (global.atk_speed >= 3 && !global.boss_morto);
    var _atk_area_max  = (global.atk_area >= 100 && !global.boss_morto);
    var _crit_max      = (global.crit_chance >= 30 && !global.boss_morto);
    var _crit_dano_max = (global.crit_dano >= 4 && !global.boss_morto);
	var _move_spd_max  = (global.player_move_speed >= 8 && !global.boss_morto);
	
    _desenhar_carta(_grid_start_x + (_space_x * 0), _grid_start_y + (_space_y * 0), "1", "+ Vida Máxima", global.max_hp, string(custo_vida) + " Madeira", c_orange, (global.wood >= custo_vida), _vida_max);
    _desenhar_carta(_grid_start_x + (_space_x * 1), _grid_start_y + (_space_y * 0), "2", "+ Dano Base", global.player_damage, string(custo_dano) + " Carvão", c_dkgray, (global.carvao >= custo_dano), _dano_max);
    _desenhar_carta(_grid_start_x + (_space_x * 2), _grid_start_y + (_space_y * 0), "3", "+ Vel. Minerar", global.mine_speed, string(custo_vel) + " Ferro", c_ltgray, (global.iron >= custo_vel), false);
    
    _desenhar_carta(_grid_start_x + (_space_x * 0), _grid_start_y + (_space_y * 1), "4", "+ Drop Extra", global.mine_yield, string(custo_yield) + " Ouro", c_yellow, (global.gold >= custo_yield), false);
    _desenhar_carta(_grid_start_x + (_space_x * 1), _grid_start_y + (_space_y * 1), "5", "+ Vel. Ataque", global.atk_speed, string(custo_atk_speed) + " Ouro", c_yellow, (global.gold >= custo_atk_speed), _atk_spd_max);
	_desenhar_carta(_grid_start_x + (_space_x * 2), _grid_start_y + (_space_y * 1), "6", "+ Vel. Movimento", global.player_move_speed, string(custo_move_speed) + " Carvão", c_dkgray, (global.carvao >= custo_move_speed), _move_spd_max);
    
    _desenhar_carta(_grid_start_x + (_space_x * 0), _grid_start_y + (_space_y * 2), "7", "+ Área Ataque", global.atk_area, string(custo_atk_area) + " Ferro", c_ltgray, (global.iron >= custo_atk_area), _atk_area_max);
    _desenhar_carta(_grid_start_x + (_space_x * 1), _grid_start_y + (_space_y * 2), "8", "+ Chance Crítico", string(global.crit_chance) + "%", string(custo_critico) + " Almas", c_aqua, (global.souls >= custo_critico), _crit_max);
    _desenhar_carta(_grid_start_x + (_space_x * 2), _grid_start_y + (_space_y * 2), "9", "+ Dano Crítico", string(global.crit_dano) + "x", string(custo_crit_dano) + " Almas", c_aqua, (global.souls >= custo_crit_dano), _crit_dano_max);
}
// ==========================================
// PÁGINA 1: MAGIA E ALIADOS
// ==========================================
else if (menu_page == 1) {
    // Checagens com os valores EXATOS do seu Evento Step para os aliados
    var _fada_dano_max  = (global.fairy_damage >= 30 && !global.boss_morto);
    var _fada_vel_max   = (global.fairy_atk_speed <= 50 && !global.boss_morto); // Atenção: aqui o limite é "menor que", pois o frame cai!
    var _fada_visao_max = (global.fairy_vision >= 400 && !global.boss_morto);
    
    var _burguer_cura_max = (global.burguer_heal_amount >= 30 && !global.boss_morto);
    var _burguer_vel_max  = (global.burguer_heal_speed <= 350 && !global.boss_morto); // Limite de frame caindo

    var _fada_status = (global.fairy_unlocked == 0) ? "BLOQUEADO" : global.fairy_damage;
    var _fada_unlock_c = (global.fairy_unlocked == 0) ? custo_fada_unlock : custo_fada_dano;
    var _fada_txt = (global.fairy_unlocked == 0) ? "DESBLOQUEAR" : "+ Dano Fada";
    
    // A primeira carta não trava no desbloqueio, apenas quando upa o dano
    var _trava_fada_1 = (global.fairy_unlocked == 1) ? _fada_dano_max : false;
    _desenhar_carta(_grid_start_x + (_space_x * 0), _grid_start_y + (_space_y * 0), "1", _fada_txt, _fada_status, string(_fada_unlock_c) + " Almas", c_aqua, (global.souls >= _fada_unlock_c), _trava_fada_1);
    
    if (global.fairy_unlocked == 1) {
        _desenhar_carta(_grid_start_x + (_space_x * 1), _grid_start_y + (_space_y * 0), "2", "+ Vel. Atk Fada", global.fairy_atk_speed, string(custo_fada_vel) + " Ouro", c_yellow, (global.gold >= custo_fada_vel && global.fairy_atk_speed > 10), _fada_vel_max);
        _desenhar_carta(_grid_start_x + (_space_x * 2), _grid_start_y + (_space_y * 0), "3", "+ Range Fada", global.fairy_vision, string(custo_fada_range) + " Ferro", c_ltgray, (global.iron >= custo_fada_range), _fada_visao_max);
    }
    
    var _burg_status = (global.burguer_unlocked == 0) ? "BLOQUEADO" : global.burguer_heal_amount;
    var _burg_unlock_c = (global.burguer_unlocked == 0) ? custo_burguer_unlock : custo_burguer_heal;
    var _burg_txt = (global.burguer_unlocked == 0) ? "DESBLOQUEAR" : "+ Cura Hambúrguer";
    var _burg_cor_c = (global.burguer_unlocked == 0) ? c_aqua : c_yellow; 
    var _burg_recurso = (global.burguer_unlocked == 0) ? global.souls : global.gold;
    var _burg_recurso_txt = (global.burguer_unlocked == 0) ? " Almas" : " Ouro";
    
    var _trava_burg_4 = (global.burguer_unlocked == 1) ? _burguer_cura_max : false;
    _desenhar_carta(_grid_start_x + (_space_x * 0), _grid_start_y + (_space_y * 1), "4", _burg_txt, _burg_status, string(_burg_unlock_c) + _burg_recurso_txt, _burg_cor_c, (_burg_recurso >= _burg_unlock_c), _trava_burg_4);
    
    if (global.burguer_unlocked == 1) {
        _desenhar_carta(_grid_start_x + (_space_x * 1), _grid_start_y + (_space_y * 1), "5", "+ Vel. Cura", global.burguer_heal_speed, string(custo_burguer_speed) + " Ferro", c_ltgray, (global.iron >= custo_burguer_speed && global.burguer_heal_speed > 30), _burguer_vel_max);
    }
}

// ==========================================
// RODAPÉ / RESSUSCITAR
// ==========================================
draw_set_halign(fa_center);
draw_set_alpha(0.8 + sin(tempo_menu * 0.1) * 0.2); 
draw_set_color(c_lime);
draw_text(_gui_w / 2, _gui_h - 50, "Pressione [ESPAÇO] para Ressuscitar"); // Mantido exato
draw_set_alpha(1);
draw_set_halign(fa_left);

// ==========================================
// DESENHAR A DEUSA (Lado Direito Sem Brilho)
// ==========================================
var _gscale = 2.5; 
var _goddess_w = sprite_get_width(goddess_sprite) * _gscale;
var _goddess_h = sprite_get_height(goddess_sprite) * _gscale;

// Empurrei a deusa bem pra direita, quase vazando a tela (Mude o +20 se ela vazar muito)
var _gx = _gui_w - _goddess_w + 260; 
var _gy = _gui_h - _goddess_h; 

draw_sprite_ext(goddess_sprite, goddess_frame, _gx, _gy, _gscale, _gscale, 0, c_white, 1);