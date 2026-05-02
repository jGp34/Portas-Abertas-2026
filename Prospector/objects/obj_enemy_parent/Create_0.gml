// Stats (serão sobrescritos pelos filhos)
hp = 10;
max_hp = 10;
damage = 1;
move_spd = 1.5;
detect_radius = 200;  // Raio para começar a seguir
attack_dist = 20;     // Distância para dar dano
attack_cooldown = 60; // 1 segundo se o jogo for 60fps
can_attack = true;
attack_hit = false;

// Variáveis de Animação (serão preenchidas pelos filhos)
spr_idle = -1;
spr_walk = -1;
spr_attack = -1;
spr_death = -1;

base_scale = 1;

// Controle de Estado
state = "idle";

// --- NOVAS VARIÁVEIS DE ÁUDIO ---
snd_hit = -1;    // Som quando o ataque acerta (ex: sfx_goblin_attack)
snd_miss = -1;   // Som quando o ataque erra (ex: swing de espada, tiro de flecha)
snd_death = -1;  // Som de morte
snd_pitch = 1.0; // Pitch para o sfx_attack_swing (muda por inimigo)

// --- VARIÁVEIS DE PATRULHA / WANDER ---
can_wander = false;      // Desligado por padrão para os Goblins/Orcs
wander_timer = 0;        // Cronômetro da ação
wander_state = "idle";   // Controla se está no tempo de andar ou parar
wander_dir = 0;          // Direção do movimento