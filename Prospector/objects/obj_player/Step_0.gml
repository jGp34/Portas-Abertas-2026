// 1. CHECK IF WE ARE CURRENTLY ACTING
var _is_acting = (sprite_index == spr_pickaxe || sprite_index == spr_axe || sprite_index == spr_sword);

// 2. GET MOVEMENT INPUTS
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = 4;

if (!_is_acting) {
    // 3. AÇÃO INDEPENDENTE: Apenas a espada ("C")
    if (keyboard_check_pressed(ord("C"))) {
        sprite_index = spr_sword;
        image_index = 0;
    } 
    // 4. MOVEMENT & WALKING ANIMATION
    else {
        if (_hinput != 0 || _vinput != 0) {
            var _dir = point_direction(0, 0, _hinput, _vinput);
            var _hspd = lengthdir_x(_move_speed, _dir);
            var _vspd = lengthdir_y(_move_speed, _dir);

            // Colisão Horizontal
            if (place_meeting(x + _hspd, y, obj_colision)) {
                while (!place_meeting(x + sign(_hspd), y, obj_colision)) {
                    x += sign(_hspd);
                }
                _hspd = 0;
            }
            x += _hspd;

            // Colisão Vertical
            if (place_meeting(x, y + _vspd, obj_colision)) {
                while (!place_meeting(x, y + sign(_vspd), obj_colision)) {
                    y += sign(_vspd);
                }
                _vspd = 0;
            }
            y += _vspd;
            
            sprite_index = spr_walk; 
        } else {
            sprite_index = spr_still; 
        }
    }
} else {
    // 5. WAIT FOR ACTION TO FINISH
    if (image_index >= image_number - 1) {
        sprite_index = spr_still; // Volta para idle quando acaba o golpe
    }
}

// 6. FLIPPING
if (_hinput != 0) {
    image_xscale = abs(image_xscale) * sign(_hinput); 
}