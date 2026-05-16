// Herdar todas as variáveis de controle do pai
event_inherited();

// Stats do Sahur
hp = 85;
max_hp = hp;
damage = 50;
move_spd = 2.5;         // Ele corre bem rápido!
attack_dist = 20;       // Distância corpo a corpo curta
detect_radius = 9999;   // Visão infinita: incansável atrás do jogador

base_scale = 0.4; 
image_xscale = base_scale;
image_yscale = base_scale;
attack_cooldown = 1;

// Atribuir as animações específicas
spr_idle = spr_sahur_walk; // Como ele não para, deixamos o idle igual ao walk
spr_walk = spr_sahur_walk;
spr_attack = spr_sahur_attack;
spr_death = spr_sahur_death;

// ---> SONS DO SAHUR <---
snd_hit = sfx_sahur_attack;   // Toca quando a mordida acerta o player
snd_miss = sfx_attack_swing;  // Toca o som de "vento" se ele errar a mordida
snd_death = sfx_sahur_death;  // Toca na exata hora que a vida zera

souls_para_dropar = 1;
souls_scale_mult = 1;

// --- ESTADO INICIAL DE NASCIMENTO ---
state = "birth"; 
sprite_index = spr_sahur_birth;
image_index = 0;