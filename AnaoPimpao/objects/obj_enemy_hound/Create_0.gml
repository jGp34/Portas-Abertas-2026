// Herdar os comportamentos e variáveis do pai
event_inherited();

// Sobrescrever Stats
hp = 1;
damage = 10;
move_spd = 3.0;
attack_dist = 20;
// Atribuir as animações específicas do Goblin
spr_idle = spr_hound_still;
spr_walk = spr_hound_walk;
spr_attack = spr_hound_attack;
spr_death = spr_hound_death;

// Configurar e aplicar a escala inicial
base_scale = 0.6; 
image_xscale = base_scale; // <- Aplica a largura imediatamente ao spawnar
image_yscale = base_scale; // <- Aplica a altura imediatamente ao spawnar

snd_hit = sfx_hound_attack;
snd_miss = sfx_attack_swing;
snd_death = sfx_hound_death;
snd_pitch = 2.0;

// --- HABILIDADES ÚNICAS ---
can_wander = true; // Permite que o Hound patrulhe quando não estiver vendo o jogador      // Direção do movimento

// Souls
souls_para_dropar = 1;
souls_scale_mult = 1;