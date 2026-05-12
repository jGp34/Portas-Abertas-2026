event_inherited();

// --- STATS ÚNICOS DO KOBOLD ---
hp = 120;
max_hp = 120;
move_spd = 2.0;

// Animações (crie ou troque para os nomes das suas sprites)
spr_idle = spr_kobold_still;
spr_walk = spr_kobold_walk;
spr_attack = spr_kobold_still; // Ele não ataca, mas previne erros
spr_death = spr_kobold_death;

base_scale = 0.3;
image_xscale = base_scale;
image_yscale = base_scale;

// --- DROP DE MORTE ---
souls_para_dropar = 3;
souls_scale_mult = 1.6; 

// --- VARIÁVEIS DE COMPORTAMENTO ---
destino_x = x; // Preenchido pelo Spawner
destino_y = y; // Preenchido pelo Spawner
meu_numero_spawn = 1; // Preenchido pelo Spawner

is_moving = true;
move_timer = irandom_range(0.5 * 60, 2 * 60); // Tempo inicial (0.5s a 2s)
foi_atacado = false;
is_fading = false; // Controle de sumir no final
prev_hp = hp; // Usado para detectar quando tomou um hit

snd_death = sfx_kobold_death;