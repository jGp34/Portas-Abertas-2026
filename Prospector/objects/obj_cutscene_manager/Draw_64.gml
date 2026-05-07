// --- obj_cutscene_manager -> Draw GUI ---
if (array_length(scenes) == 0) exit; // Trava de segurança

draw_set_alpha(1); 
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

draw_set_alpha(fade_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);