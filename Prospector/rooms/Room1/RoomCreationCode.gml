// Abre o arquivo de save (se não existir, o GameMaker lê na memória temporária)
//file_delete("meu_save.ini");
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
global.max_hp = ini_read_real("Upgrades", "max_hp", 10);
global.player_damage = ini_read_real("Upgrades", "dano", 5);
global.mine_speed = ini_read_real("Upgrades", "mine_speed", 1); 
global.mine_yield = ini_read_real("Upgrades", "mine_yield", 1); 

// ---> ADICIONADO: Novos Upgrades <---
global.atk_speed = ini_read_real("Upgrades", "atk_speed", 1); // 1 = 100% da velocidade da animação
global.player_move_speed = ini_read_real("Upgrades", "move_speed", 4); // 4 é a velocidade base
global.atk_area = ini_read_real("Upgrades", "atk_area", 60); // 60 é o raio base
global.crit_chance = ini_read_real("Upgrades", "crit_chance", 0); // 0% de chance base

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