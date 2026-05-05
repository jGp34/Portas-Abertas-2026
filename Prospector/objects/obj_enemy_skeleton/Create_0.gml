// Herda as variáveis básicas
event_inherited();

// Sobrescreve os Stats
hp = 20; 
damage = 10; // Esse dano será repassado ao projétil
move_spd = 1.0;

// --- SISTEMA DE DISTÂNCIA E TIRO ---
detect_radius = 300; // Vê o jogador de muito longe

ideal_dist_min = 120; // Se o jogador chegar a menos de 120 pixels, ele FOGE!
ideal_dist_max = 200; // Se ficar mais longe que 200 pixels, ele APROXIMA!

shoot_cooldown = 120; // Atira a cada 1.5 segundos (90 frames)
shoot_timer = shoot_cooldown;

// Animações (Troque pelos nomes das suas sprites)
spr_idle = spr_skeleton_still;
spr_walk = spr_skeleton_walk;
spr_attack = spr_skeleton_attack;
spr_death = spr_skeleton_death;

base_scale = 1; 
image_xscale = base_scale;
image_yscale = base_scale;

// Sons 
snd_hit = -1; // Não ataca corpo a corpo
snd_miss = sfx_skeleton_attack; // Som de atirar/lançar a magia
snd_death = sfx_skeleton_death; // Som de morte
snd_pitch = 1.0;

souls_para_dropar = 2; // Drops mais almas por ser ranged
souls_scale_mult = 1.3
can_wander = true;