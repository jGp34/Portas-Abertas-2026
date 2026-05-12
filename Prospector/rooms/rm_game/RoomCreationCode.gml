// Abre o arquivo de save (se não existir, o GameMaker lê na memória temporária)
file_delete("meu_save.ini");
ini_open("meu_save.ini");

// ==========================================
// 1. RECURSOS
// ==========================================
global.carvao = ini_read_real("Recursos", "carvao", 0);
global.wood = ini_read_real("Recursos", "wood", 0);
global.iron = ini_read_real("Recursos", "iron", 0);
global.gold = ini_read_real("Recursos", "gold", 0);
global.souls = ini_read_real("Recursos", "souls", 0); // <--- ADICIONADO: Souls

// ==========================================
// 2. UPGRADES
// ==========================================
global.boss_morto = ini_read_real("Progresso", "boss_morto", 0);
global.max_hp = ini_read_real("Upgrades", "max_hp", 15);
global.player_damage = ini_read_real("Upgrades", "dano", 10);
global.mine_speed = ini_read_real("Upgrades", "mine_speed", 1); 
global.mine_yield = ini_read_real("Upgrades", "mine_yield", 1); 
global.crit_dano = ini_read_real("Upgrades", "crit_dano", 2);

// ---> ADICIONADO: Novos Upgrades <---
global.atk_speed = ini_read_real("Upgrades", "atk_speed", 1); // 1 = 100% da velocidade da animação
global.player_move_speed = ini_read_real("Upgrades", "move_speed", 4); // 4 é a velocidade base
global.atk_area = ini_read_real("Upgrades", "atk_area", 60); // 60 é o raio base
global.crit_chance = ini_read_real("Upgrades", "crit_chance", 0); // 0% de chance base
// ---> ADICIONADO: Aliado Fada <---
global.fairy_unlocked = ini_read_real("Upgrades", "fairy_unlocked", 0); // 0 = Bloqueada, 1 = Desbloqueada
global.fairy_damage = ini_read_real("Upgrades", "fairy_dano", 5);       // Dano base
global.fairy_atk_speed = ini_read_real("Upgrades", "fairy_atk", 120);   // 120 frames = 2 segundos
global.fairy_vision = ini_read_real("Upgrades", "fairy_vision", 250);
// --- Variáveis Globais Sugeridas ---
global.burguer_unlocked = ini_read_real("Upgrades", "burguer_unlocked", 0);
global.burguer_heal_amount = ini_read_real("Upgrades", "burguer_heal_amount", 5); // Cura 5 base
global.burguer_heal_speed = ini_read_real("Upgrades", "burguer_heal_speed", 480); //480 frames = 8 segundos
// O jogador nasce com a vida cheia baseada no upgrade atual
global.player_hp = global.max_hp;

ini_close();

// ==========================================
// 3. OTIMIZAÇÃO (Prefetch)
// ==========================================
// Carrega as texturas pesadas dos personagens na memória de vídeo antecipadamente
sprite_prefetch(spr_player_walk);
sprite_prefetch(spr_player_pickaxe);
sprite_prefetch(spr_player_axe);
sprite_prefetch(spr_player_sword);
// fazer isso para os sprites dos inimigos também se eles forem pesados