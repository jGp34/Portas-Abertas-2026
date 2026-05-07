// --- obj_intro_manager -> Draw GUI ---

// 1. DESENHAR A IMAGEM (Antes do Fade)
draw_set_alpha(1); // Garante opacidade cheia para a imagem

var _spr = scenes[current_scene].spr;

// Pegamos o tamanho original da imagem gerada
var _sw = sprite_get_width(_spr);
var _sh = sprite_get_height(_spr);

// Calculamos a escala necessária para fitar na largura e na altura da GUI
var _scale_x = gui_width / _sw;
var _scale_y = gui_height / _sh;

// Usamos a MENOR escala para garantir que a imagem inteira apareça (Letterbox)
var _final_scale = min(_scale_x, _scale_y);

// Desenha a imagem centralizada na GUI
draw_sprite_ext(_spr, 0, gui_width/2, gui_height/2, _final_scale, _final_scale, 0, c_white, 1);

// =======================================================
// ---> NOVIDADE: INDICADOR DE PULAR (Fixo, maior e mais na borda)
// =======================================================

// 1. Define o quão maior o botão vai ficar (Aumentado de 1.5 para 2.5)
var _enter_scale = 2.5; 

// 2. Calcula as bordas REAIS da imagem centralizada na tela
var _img_real_w = _sw * _final_scale;
var _img_real_h = _sh * _final_scale;

var _img_right_edge = (gui_width / 2) + (_img_real_w / 2);
var _img_bottom_edge = (gui_height / 2) + (_img_real_h / 2);

// 3. Pega os dados de tamanho da sprite já multiplicados pela nova escala
var _enter_w = sprite_get_width(spr_enter) * _enter_scale;
var _enter_h = sprite_get_height(spr_enter) * _enter_scale;

// Compensação matemática caso o "Origin" da sua spr_enter seja Middle Center ou Top Left
var _enter_xoff = sprite_get_xoffset(spr_enter) * _enter_scale;
var _enter_yoff = sprite_get_yoffset(spr_enter) * _enter_scale;

// Distância da borda. 
// DICA: 0 cola exatamente na borda da imagem. Números negativos (-10, -20) empurram para fora dela!
var _margem_x = -50; 
var _margem_y = -50; 

// 4. Posiciona o botão exatamente no cantinho inferior direito da imagem
var _pos_x = _img_right_edge - _enter_w + _enter_xoff - _margem_x;
var _pos_y = _img_bottom_edge - _enter_h + _enter_yoff - _margem_y;

// Desenha a sprite estática e totalmente opaca (alpha em 1)
draw_sprite_ext(spr_enter, 0, _pos_x, _pos_y, _enter_scale, _enter_scale, 0, c_white, 1);

// =======================================================
// 2. DESENHAR O FADE (Por cima da imagem e do botão)
// =======================================================
draw_set_alpha(fade_alpha);
draw_set_color(c_black);
// Usamos as variáveis gui_width/gui_height para garantir o tamanho do retângulo
draw_rectangle(0, 0, gui_width, gui_height, false);

// Reseta o alpha para não estragar a renderização do resto do jogo
draw_set_alpha(1);