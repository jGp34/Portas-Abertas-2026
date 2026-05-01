ini_open("meu_save.ini");

// Lendo os upgrades salvos (CORRIGIDO PARA "dano")
global.max_hp = ini_read_real("Upgrades", "max_hp", 100);
global.player_damage = ini_read_real("Upgrades", "dano", 5); // <--- A MUDANÇA ESTÁ AQUI
global.mine_speed = ini_read_real("Upgrades", "mine_speed", 1); // 1 = 100% de vel
global.mine_yield = ini_read_real("Upgrades", "mine_yield", 1); // 1 = dropa 1 por vez

// O jogador nasce com a vida cheia baseada no upgrade atual
global.player_hp = global.max_hp; 

ini_close();