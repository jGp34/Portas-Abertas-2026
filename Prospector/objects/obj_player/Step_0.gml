// 1. CHECK FOR ACTION INPUTS
// We use keyboard_check_pressed so it only triggers once per tap
if (keyboard_check_pressed(ord("Z"))) {
    sprite_index = spr_pickaxe;
    image_index = 0; // Forces the animation to start at frame 0
} else if (keyboard_check_pressed(ord("X"))) {
    sprite_index = spr_axe;
    image_index = 0;
} else if (keyboard_check_pressed(ord("C"))) {
    sprite_index = spr_sword;
    image_index = 0;
}

// 2. CHECK IF WE ARE CURRENTLY ACTING
// This creates a temporary variable that is TRUE if any tool sprite is playing
var _is_acting = (sprite_index == spr_pickaxe || sprite_index == spr_axe || sprite_index == spr_sword);

// 3. MOVEMENT & NORMAL ANIMATION
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = 4;

if (!_is_acting) {
    // We are NOT acting, so we are allowed to move and play normal animations
    if (_hinput != 0 || _vinput != 0) {
        var _dir = point_direction(0, 0, _hinput, _vinput);
        x += lengthdir_x(_move_speed, _dir);
        y += lengthdir_y(_move_speed, _dir);
        
        sprite_index = spr_walk; 
    } else {
        sprite_index = spr_still; 
    }
} else {
    // We ARE acting! Let's check if the animation has reached its final frame.
    // image_number is the total frames. We subtract 1 because image_index starts at 0.
    if (image_index >= image_number - 1) {
        sprite_index = spr_still; // The animation finished, return to normal!
    }
}

// 4. SCALING 
image_yscale = my_scale;

// 5. FLIPPING
if (_hinput > 0) {
    image_xscale = my_scale; 
} 
else if (_hinput < 0) {
    image_xscale = -my_scale; 
}