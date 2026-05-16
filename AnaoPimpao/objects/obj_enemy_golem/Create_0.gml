// Herda as variáveis básicas do parent
event_inherited();

// --- STATS DO GOLEM ---
hp = 100; 
max_hp = 100;
damage = 50; // Dano repassado ao projétil
move_spd = 0.8; // Um pouco mais lento que o esqueleto (que era 1.0)

// --- SISTEMA DE TIRO ---
// Ele atira a cada 2.5 segundos (150 frames a 60FPS) para não ser muito rápido
shoot_cooldown = 150; 
shoot_timer = shoot_cooldown;

// --- ANIMAÇÕES ---
// (Lembre-se de trocar pelos nomes das sprites do seu Golem)
spr_still = spr_golem_still;
spr_walk = spr_golem_walk;
spr_attack = spr_golem_attack;
spr_death = spr_golem_death;

base_scale = 0.7; 
image_xscale = base_scale;
image_yscale = base_scale;

// --- ÁUDIO ---
snd_hit = -1; 
snd_miss = sfx_golem_attack; // Troque para o som de tiro do golem se tiver
snd_death = sfx_golem_death; // Troque para o som de morte do golem se tiver
snd_pitch = 1.0; // Pitch um pouco mais grave para parecer pesado

// --- DROPS ---
souls_para_dropar = 3; 
souls_scale_mult = 1.6;

// O Golem sempre vai patrulhar (wander)
can_wander = true;