draw_self(); // Desenha o player

// DESENHO DE DEBUG (Remova depois)
if (sprite_index == spr_sword && image_index >= 10 && image_index <= 15) {
    var _dist = 60; // Mesma distância do seu código de dano
    var _dir = (image_xscale > 0) ? 0 : 180;
    var _hx = x + lengthdir_x(_dist, _dir);
    var _hy = y;
    
    draw_set_alpha(0.5);
    draw_circle_color(_hx, _hy, 50, c_red, c_red, false); // Círculo vermelho onde o dano ocorre
    draw_set_alpha(1);
}