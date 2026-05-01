// Herdar os comportamentos e variáveis do pai
event_inherited();

// Sobrescrever Stats
hp = 60;
damage = 20;
move_spd = 2.5;
attack_dist = 40;

// Atribuir as animações específicas do Goblin
spr_idle = spr_ogre_still;
spr_walk = spr_ogre_walk;
spr_attack = spr_ogre_attack;
spr_death = spr_ogre_death;

// Configurar e aplicar a escala inicial
base_scale = 0.5; 
image_xscale = base_scale; // <- Aplica a largura imediatamente ao spawnar
image_yscale = base_scale; // <- Aplica a altura imediatamente ao spawnar

snd_hit = sfx_ogre_attack;
snd_miss = sfx_attack_swing;
snd_death = sfx_ogre_death;
snd_pitch = 0.7;