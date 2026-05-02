draw_self(); // Desenha o player

// DESENHO DE DEBUG (Remova depois)
if (sprite_index == spr_player_sword && image_index >= 10 && image_index <= 15) {
    
    // Matemática nova (Cresce junto com o upgrade)
    var _dist = 80 + (global.atk_area - 60); 
    var _raio = global.atk_area;
    var _dir = (image_xscale > 0) ? 0 : 180;
    var _hx = x + lengthdir_x(_dist, _dir);
    var _hy = y;
    
    // Visual antigo (Preenchido e transparente)
    draw_set_alpha(0.5);
    draw_circle_color(_hx, _hy, _raio, c_red, c_red, false); // false = círculo cheio
    draw_set_alpha(1); // Reseta a transparência para não afetar o resto do jogo
}