var _fps = game_get_speed(gamespeed_fps);

// Tempos
tempo_primeira_onda = 5 * _fps; // Começa aos 5 segundos
tempo_entre_ondas = 15 * _fps; // Depois, a cada 15 segundos

onda_atual = 0;

// =======================================================
// DEFINIÇÃO DAS ONDAS
// =======================================================
// Cada índice (0, 1, 2...) é uma onda diferente. 
// Coloque dentro do array exatamente os inimigos que você quer que nasçam.


ondas[0] = [obj_enemy_hound]; 
ondas[1] = [obj_enemy_hound, obj_enemy_hound];
ondas[2] = [obj_enemy_skeleton];
ondas[3] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_hound];
ondas[4] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_skeleton];
ondas[5] = [obj_enemy_golem];
ondas[7] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_skeleton, obj_enemy_skeleton];
ondas[8] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_hound, obj_enemy_golem];
ondas[9] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_hound, obj_enemy_hound, obj_enemy_skeleton, obj_enemy_skeleton, obj_enemy_golem];
ondas[10] = [obj_enemy_knight] 
ondas[11] = [obj_enemy_hound, obj_enemy_hound, obj_enemy_hound, obj_enemy_hound, obj_enemy_skeleton, obj_enemy_skeleton, obj_enemy_golem];

// Inicia o relógio para a primeira onda
alarm[0] = tempo_primeira_onda;