// Herdar variáveis do obj_enemy_parent
event_inherited();

// Sobrescrever Stats do Boss
hp = 3000;
max_hp = hp;
move_spd = 1.0;       // Caminhada imponente e mais lenta
attack_dist = 80;     // Distância para iniciar os golpes
attack_cooldown = 45; // Tempo de pausa entre ataques
damage = 100;
base_scale = 0.75;
image_xscale = base_scale;
image_yscale = base_scale;

// --- VARIÁVEIS EXCLUSIVAS DO BOSS ---
state = "intro_walk"; 
attack_count = 0;     
kneel_loops = 0;      
chase_timer = 0;

sound_played = false;
souls_para_dropar = 10;
souls_scale_mult = 2;


// Adicione ao final do Create do cavaleiro:
kneel_attack_timer = 0;
kneel_attack_index = 0; // Qual cor do arco-íris é a próxima
rainbow_colors = [c_red, c_orange, c_yellow, c_green, c_blue, make_color_rgb(75, 0, 130), make_color_rgb(148, 0, 211)];

// --- VARIÁVEIS DA FASE 2 ---
phase = 1;                     // Controla em qual fase o boss está
phase2_timer = 0;              // Timer para soltar vomit/buff enquanto anda
phase2_next_attack = "vomit";  // Alterna qual o próximo ataque à distância
vomit_spawned = false;		   // Trava para spawnar apenas 1 inimigo por vômito
// Encontra o ponto de espera
target_wait = instance_nearest(x, y, obj_knight_wait);

// Variáveis para desenhar o efeito visual do corte
draw_boss_slash = false;
slash_frame = 0;
snd_miss = sfx_attack_swing;
audio_play_sound(sfx_knight_spawn, 2, false);