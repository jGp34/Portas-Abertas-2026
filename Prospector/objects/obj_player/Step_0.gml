// 1. CHECK IF WE ARE CURRENTLY ACTING
var _is_acting = (sprite_index == spr_pickaxe || sprite_index == spr_axe || sprite_index == spr_sword);

// 2. GET MOVEMENT INPUTS
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = 4;

if (!_is_acting) {
    // 3. CHECK FOR NEW ACTIONS (Only if we aren't doing something else)
    if (keyboard_check_pressed(ord("Z"))) {
        sprite_index = spr_pickaxe;
        image_index = 0; 
    } else if (keyboard_check_pressed(ord("X"))) {
        sprite_index = spr_axe;
        image_index = 0;
    } else if (keyboard_check_pressed(ord("C"))) {
        sprite_index = spr_sword;
        image_index = 0;
    } 
    // 4. MOVEMENT & WALKING ANIMATION
    else {
        if (_hinput != 0 || _vinput != 0) {
            var _dir = point_direction(0, 0, _hinput, _vinput);
            x += lengthdir_x(_move_speed, _dir);
            y += lengthdir_y(_move_speed, _dir);
            
            sprite_index = spr_walk; 
        } else {
            sprite_index = spr_still; 
        }
    }
} else {
    // 5. WAIT FOR ACTION TO FINISH
    if (image_index >= image_number - 1) {
        sprite_index = spr_still; // Animation done, go back to idle
    }
}

// 6. FLIPPING (Fixed to respect Room Editor scaling)
if (_hinput != 0) {
    // abs() gets the positive size (0.125), sign() gets the direction (1 or -1)
    image_xscale = abs(image_xscale) * sign(_hinput); 
}