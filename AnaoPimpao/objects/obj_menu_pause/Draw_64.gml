if (global.is_paused) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    if (sprite_exists(pause_sprite)) {
        draw_sprite_stretched(pause_sprite, 0, 0, 0, _gui_w, _gui_h);
    }
    
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    
    if (pause_state == "main") {
        var _bw = 300; 
        var _bh = 260; 
        var _bx = (_gui_w - _bw) / 2;
        var _by = (_gui_h - _bh) / 2;
        
        draw_set_alpha(0.9);
        draw_set_color(make_color_rgb(15, 15, 20));
        draw_roundrect_ext(_bx, _by, _bx + _bw, _by + _bh, 12, 12, false);
        
        draw_set_alpha(1);
        draw_set_color(c_dkgray);
        draw_roundrect_ext(_bx, _by, _bx + _bw, _by + _bh, 12, 12, true);
        draw_roundrect_ext(_bx - 1, _by - 1, _bx + _bw + 1, _by + _bh + 1, 13, 13, true);
        
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 215, 0)); 
        draw_text(_gui_w / 2, _by + 40, "PAUSA");
        
        var _oy = _by + 110;
        var _espacamento = 45;
        
        for (var i = 0; i < array_length(pause_options); i++) {
            if (pause_selected == i) {
                draw_set_color(c_lime);
                draw_text(_gui_w / 2, _oy + (i * _espacamento), ">  " + pause_options[i] + "  <");
            } else {
                draw_set_color(c_white);
                draw_text(_gui_w / 2, _oy + (i * _espacamento), pause_options[i]);
            }
        }
    } 
    else if (pause_state == "controls") {
        var _cw = 500; 
        var _ch = 530; // AUMENTADO AQUI (De 500 para 530) para dar espaço ao novo cheat!
        var _cx = (_gui_w - _cw) / 2;
        var _cy = (_gui_h - _ch) / 2;
        
        draw_set_alpha(0.9);
        draw_set_color(make_color_rgb(15, 15, 20));
        draw_roundrect_ext(_cx, _cy, _cx + _cw, _cy + _ch, 12, 12, false);
        
        draw_set_alpha(1);
        draw_set_color(c_dkgray);
        draw_roundrect_ext(_cx, _cy, _cx + _cw, _cy + _ch, 12, 12, true);
        draw_roundrect_ext(_cx - 1, _cy - 1, _cx + _cw + 1, _cy + _ch + 1, 13, 13, true);
        
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text(_gui_w / 2, _cy + 40, "CONTROLES & CHEATS");
        
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        draw_set_color(c_white);
        
        var _tx = _cx + 40;
        var _ty = _cy + 80;
        var _t_esp = 28;
        
        draw_text(_tx, _ty, "Mover: W, A, S, D ou Setinhas"); _ty += _t_esp;
        draw_text(_tx, _ty, "Atacar: Z ou C"); _ty += _t_esp;
        draw_text(_tx, _ty, "Coletar Recursos/Gênio: E"); _ty += _t_esp;
        draw_text(_tx, _ty, "Ver Atributos: Segurar TAB"); _ty += _t_esp;
        draw_text(_tx, _ty, "Pausar Jogo: ESC"); _ty += _t_esp;
		draw_text(_tx, _ty, "Selecionar: Espaço ou Enter"); _ty += _t_esp;
        draw_text(_tx, _ty, "Tela Cheia: F11"); _ty += _t_esp * 2;
        
        draw_set_color(make_color_rgb(200, 150, 255));
        draw_text(_tx, _ty, "CHEATKEYS"); _ty += _t_esp;
        
        draw_set_color(c_ltgray);
        // ---> NOVO CHEAT ADICIONADO AQUI EM ORDEM CRONOLÓGICA (F6) <---
        draw_text(_tx, _ty, "Mostrar final: F6"); _ty += _t_esp;
        
        draw_text(_tx, _ty, "Matar personagem: F7"); _ty += _t_esp;
        draw_text(_tx, _ty, "Adicionar 9999 de recursos: F8"); _ty += _t_esp;
        draw_text(_tx, _ty, "Zerar recursos: F9"); _ty += _t_esp;
        draw_text(_tx, _ty, "Resetar personagem: F10"); _ty += _t_esp;
        
        draw_set_halign(fa_center);
        draw_set_color(c_yellow);
        draw_text(_gui_w / 2, _cy + _ch - 40, "Pressione ESPAÇO para Voltar");
    }
    
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}