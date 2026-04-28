
timer_atual = 0;
distancia_minima = 40; // Quão perto o player precisa estar
image_index = irandom(image_number - 1);
image_speed = random_range(0.8, 1.2);

// --- TEMPO DE MINERAÇÃO DINÂMICO ---
var _ciclos_desejados = 2;

// Lê automaticamente as configurações da sua sprite (16 frames, 15 fps)
var _frames_da_animacao = sprite_get_number(spr_player_axe); 
var _fps_da_animacao = sprite_get_speed(spr_player_axe); 

// Calcula os segundos exatos e converte para os frames do jogo
var _segundos_necessarios = (_frames_da_animacao / _fps_da_animacao) * _ciclos_desejados;
tempo_mineracao_max = round(_segundos_necessarios * game_get_speed(gamespeed_fps));

state = "growing"; // Estados: "growing", "idle", "falling", "waiting"
regrow_timer = 0;

// Salva a sprite original para quando a árvore crescer novamente
sprite_base = sprite_index; 

// Define dinamicamente a sprite de queda baseada no objeto filho
if (object_index == obj_oak_tree) {
    sprite_fall = spr_oak_fall;
} else if (object_index == obj_birch_tree) {
    sprite_fall = spr_birch_fall;
} else {
    sprite_fall = sprite_index; // Fallback de segurança
}	