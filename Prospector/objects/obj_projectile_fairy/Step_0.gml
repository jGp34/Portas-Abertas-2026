// Efeito de partícula bonitinho deixando um rastro
// instance_create_layer(x, y, "Instances", obj_fairy_trail); // Opcional, se você quiser fazer rastro depois

if (instance_exists(target)) {
    // Busca a direção do alvo
    var _dir_to_target = point_direction(x, y, target.x, target.y);
    
    // Curva gradualmente em direção ao alvo (efeito teleguiado fluido)
    var _angle_diff = angle_difference(_dir_to_target, direction);
    direction += _angle_diff * 0.15; // 0.15 é a agilidade da curva. Ajuste a gosto!
    
    // Gira a sprite para apontar pra onde está indo
    image_angle = direction; 
} else {
    // Se o alvo morreu enquanto o tiro estava voando, procura outro!
    target = instance_nearest(x, y, obj_enemy_parent);
    
    // Se não tiver nenhum inimigo na tela, o tiro vai reto e se destrói num tempinho
    if (!instance_exists(target)) {
        image_alpha -= 0.05;
        if (image_alpha <= 0) instance_destroy();
    }
}