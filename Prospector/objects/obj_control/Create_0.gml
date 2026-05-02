ini_open("meu_save.ini");

// Lendo os upgrades salvos (CORRIGIDO PARA "dano")
global.max_hp = ini_read_real("Upgrades", "max_hp", 100);
global.player_damage = ini_read_real("Upgrades", "dano", 5); // <--- A MUDANÇA ESTÁ AQUI
global.mine_speed = ini_read_real("Upgrades", "mine_speed", 1); // 1 = 100% de vel
global.mine_yield = ini_read_real("Upgrades", "mine_yield", 1); // 1 = dropa 1 por vez
// Adicione isso junto dos outros ini_read_real:
global.atk_speed = ini_read_real("Upgrades", "atk_speed", 1); // 1 = 100% da velocidade da animação
global.player_move_speed = ini_read_real("Upgrades", "move_speed", 4); // 4 é a sua velocidade base atual
global.atk_area = ini_read_real("Upgrades", "atk_area", 60); // 60 é o seu raio base atual
// O jogador nasce com a vida cheia baseada no upgrade atual
global.player_hp = global.max_hp; 

ini_close();