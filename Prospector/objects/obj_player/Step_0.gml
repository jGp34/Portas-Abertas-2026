/* MOVIMENTACAO */
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = 4;

if (_hinput != 0 || _vinput != 0) {
	var _dir = point_direction(0, 0, _hinput, _vinput);
	x += lengthdir_x(_move_speed, _dir);
	y += lengthdir_y(_move_speed, _dir);
}