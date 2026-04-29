// Herdar os comportamentos e variáveis do pai
event_inherited();

// Sobrescrever Stats
hp = 10;
damage = 1;
move_spd = 2.0;

// Atribuir as animações específicas do Goblin
spr_idle = spr_goblin_still;
spr_walk = spr_goblin_walk;
spr_attack = spr_goblin_attack;
spr_death = spr_goblin_death;

// Configurar e aplicar a escala inicial
base_scale = 0.7; 
image_xscale = base_scale; // <- Aplica a largura imediatamente ao spawnar
image_yscale = base_scale; // <- Aplica a altura imediatamente ao spawnar