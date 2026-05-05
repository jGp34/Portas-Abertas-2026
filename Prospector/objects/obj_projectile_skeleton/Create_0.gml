// NÃO use event_inherited() aqui! Queremos que ele seja limpo.
hp = 1; // 1 de vida = morre em um hit da espada!
damage = 1; // Dano que causa ao jogador
move_spd = 2.5; // Velocidade do tiro

// --- AJUSTE DE TAMANHO ---
// Mude este valor para deixar maior ou menor (ex: 0.3 para 30%)
image_xscale = 0.3; 
image_yscale = 0.3;

// Aponta para o jogador no momento em que nasce
if (instance_exists(obj_player)) {
    // Como a origem do player é Top Centre, somamos +20 (ou +30) para mirar no peito/meio da sprite
    direction = point_direction(x, y, obj_player.x, obj_player.y + 20);
    image_angle = direction; // Vira a sprite na direção do voo
}