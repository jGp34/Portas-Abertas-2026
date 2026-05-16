// --- obj_outro_manager -> Draw GUI ---
if (array_length(scenes) == 0) exit; 

draw_set_alpha(1); 

// ---> 1. PROTEÇÃO: Desenha as imagens da cutscene <---
if (current_scene < array_length(scenes)) {
    var _spr = scenes[current_scene].spr;

    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);

    var _scale_x = gui_width / _sw;
    var _scale_y = gui_height / _sh;

    var _final_scale = min(_scale_x, _scale_y);

    draw_sprite_ext(_spr, 0, gui_width/2, gui_height/2, _final_scale, _final_scale, 0, c_white, 1);

    var _enter_scale = 2.5; 
    var _img_real_w = _sw * _final_scale;
    var _img_real_h = _sh * _final_scale;

    var _img_right_edge = (gui_width / 2) + (_img_real_w / 2);
    var _img_bottom_edge = (gui_height / 2) + (_img_real_h / 2);

    var _enter_w = sprite_get_width(spr_enter) * _enter_scale;
    var _enter_h = sprite_get_height(spr_enter) * _enter_scale;

    var _enter_xoff = sprite_get_xoffset(spr_enter) * _enter_scale;
    var _enter_yoff = sprite_get_yoffset(spr_enter) * _enter_scale;

    var _margem_x = -50; 
    var _margem_y = -50; 

    var _pos_x = _img_right_edge - _enter_w + _enter_xoff - _margem_x;
    var _pos_y = _img_bottom_edge - _enter_h + _enter_yoff - _margem_y;

    draw_sprite_ext(spr_enter, 0, _pos_x, _pos_y, _enter_scale, _enter_scale, 0, c_white, 1);
}

// ---> 2. TELA PRETA DE FADE <---
draw_set_alpha(fade_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

// ---> 3. DESENHA OS CRÉDITOS ROLANTES (VISUAL PREMIUM) <---
if (state == "credits") {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // Fundo semitransparente escuro (Deixa a última imagem da cutscene bem apagadinha ao fundo)
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(10, 10, 15));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    // Faixas de Cinema (Letterbox) no topo e embaixo
    var _faixa_h = 50; 
    
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _faixa_h, false); // Faixa Superior
    draw_rectangle(0, _gui_h - _faixa_h, _gui_w, _gui_h, false); // Faixa Inferior
    
    // Linhas Douradas dando acabamento nas faixas pretas
    draw_set_color(make_color_rgb(255, 215, 0)); // Dourado
    draw_rectangle(0, _faixa_h, _gui_w, _faixa_h + 2, false);
    draw_rectangle(0, _gui_h - _faixa_h - 2, _gui_w, _gui_h - _faixa_h, false);

    // Desenho dos textos mágicos
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    var _yy = credits_y;

    for (var i = 0; i < array_length(credits_data); i++) {
        var _item = credits_data[i];
        var _altura_bloco = 0;

        // EFEITO FADE IN/OUT: O texto some como fumaça quando encosta nas bordas!
        var _text_alpha = 1;
        if (_yy < _faixa_h + 40) _text_alpha = max(0, (_yy - _faixa_h) / 40);
        if (_yy > _gui_h - _faixa_h - 60) _text_alpha = max(0, (_gui_h - _faixa_h - _yy) / 60);

        draw_set_alpha(_text_alpha);

        // Renderização customizada baseada no tipo do texto
        if (_item.tipo == "titulo_principal") {
            draw_set_color(make_color_rgb(255, 215, 0)); // Dourado
            draw_text_transformed(_gui_w / 2, _yy, _item.texto, 1.5, 1.5, 0);
            _altura_bloco = string_height(_item.texto) * 1.5 + 40;
        }
        else if (_item.tipo == "titulo") {
            draw_set_color(make_color_rgb(200, 150, 255)); // Roxo Suave
            draw_text_transformed(_gui_w / 2, _yy, _item.texto, 1.2, 1.2, 0);
            _altura_bloco = string_height(_item.texto) * 1.2 + 20;
        }
        else if (_item.tipo == "nome") {
            draw_set_color(c_white); // Branco
            draw_text_transformed(_gui_w / 2, _yy, _item.texto, 1, 1, 0);
            _altura_bloco = string_height(_item.texto) + 40;
        }
        else if (_item.tipo == "agradecimento") {
            draw_set_color(c_aqua); // Azul Ciano
            draw_text_transformed(_gui_w / 2, _yy, _item.texto, 1.5, 1.5, 0);
            _altura_bloco = string_height(_item.texto) * 1.5 + 40;
        }
        else if (_item.tipo == "espaco") {
            _altura_bloco = 40;
        }

        // Soma o espaço do bloco atual para empurrar o próximo pra baixo
        _yy += _altura_bloco;
    }

    // Reseta configurações de vídeo para não bugar outros objetos
    draw_set_alpha(1);
    draw_set_halign(fa_left); 
}