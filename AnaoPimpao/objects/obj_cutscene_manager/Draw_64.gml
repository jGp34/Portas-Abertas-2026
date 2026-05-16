// --- obj_cutscene_manager -> Draw GUI ---
if (array_length(scenes) == 0) exit; 
draw_set_alpha(1); 

// ---> 1. DESENHA A CUTSCENE <---
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
    var _pos_x = ((gui_width / 2) + (_img_real_w / 2)) - (sprite_get_width(spr_enter) * _enter_scale) + (sprite_get_xoffset(spr_enter) * _enter_scale) + 50;
    var _pos_y = ((gui_height / 2) + (_img_real_h / 2)) - (sprite_get_height(spr_enter) * _enter_scale) + (sprite_get_yoffset(spr_enter) * _enter_scale) + 50;

    draw_sprite_ext(spr_enter, 0, _pos_x, _pos_y, _enter_scale, _enter_scale, 0, c_white, 1);
}

// ---> 2. DESENHA OS CRÉDITOS ROLANTES <---
if (show_credits && (state == "credits" || state == "fade_out_credits")) {
    var _faixa_h = 50; 

    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(10, 10, 15));
    draw_rectangle(0, 0, gui_width, gui_height, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    var _yy = credits_y;

    for (var i = 0; i < array_length(credits_data); i++) {
        var _item = credits_data[i];
        var _altura_bloco = 0;

        var _text_alpha = 1;
        if (_yy < _faixa_h + 40) _text_alpha = max(0, (_yy - _faixa_h) / 40);
        if (_yy > gui_height - _faixa_h - 60) _text_alpha = max(0, (gui_height - _faixa_h - _yy) / 60);

        draw_set_alpha(_text_alpha);

        if (_item.tipo == "titulo_principal") {
            var _matiz = (current_time * 0.08) mod 255; 
            draw_set_color(make_color_hsv(_matiz, 200, 255)); 
            draw_text_transformed(gui_width / 2, _yy, _item.texto, 1.5, 1.5, 0);
            _altura_bloco = string_height(_item.texto) * 1.5 + 40;
        }
        else if (_item.tipo == "titulo") {
            draw_set_color(make_color_rgb(200, 150, 255)); 
            draw_text_transformed(gui_width / 2, _yy, _item.texto, 1.2, 1.2, 0);
            _altura_bloco = string_height(_item.texto) * 1.2 + 20;
        }
        else if (_item.tipo == "nome") {
            draw_set_color(c_white); 
            draw_text_transformed(gui_width / 2, _yy, _item.texto, 1, 1, 0);
            _altura_bloco = string_height(_item.texto) + 40;
        }
        else if (_item.tipo == "agradecimento") {
            draw_set_color(c_aqua); 
            draw_text_transformed(gui_width / 2, _yy, _item.texto, 1.5, 1.5, 0);
            _altura_bloco = string_height(_item.texto) * 1.5 + 40;
        }
        else if (_item.tipo == "espaco") _altura_bloco = 40;

        _yy += _altura_bloco;
    }

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, _faixa_h, false); 
    draw_rectangle(0, gui_height - _faixa_h, gui_width, gui_height, false); 
    
    draw_set_color(make_color_rgb(255, 215, 0)); 
    draw_rectangle(0, _faixa_h, gui_width, _faixa_h + 2, false);
    draw_rectangle(0, gui_height - _faixa_h - 2, gui_width, gui_height - _faixa_h, false);

    draw_set_halign(fa_left); 
}

// ---> 3. MÁSCARA FINAL DE FADE <---
draw_set_alpha(fade_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);