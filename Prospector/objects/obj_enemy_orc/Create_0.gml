// Herdar os comportamentos e variáveis do pai
event_inherited();

// Sobrescrever Stats
hp = 30;
damage = 10;
move_spd = 2.2;
attack_dist = 32;

// Atribuir as animações específicas do Goblin
spr_idle = spr_orc_still;
spr_walk = spr_orc_walk;
spr_attack = spr_orc_attack;
spr_death = spr_orc_death;

// Configurar e aplicar a escala inicial
base_scale = 0.9; 
image_xscale = base_scale; // <- Aplica a largura imediatamente ao spawnar
image_yscale = base_scale; // <- Aplica a altura imediatamente ao spawnar