// Abre o arquivo de save (se não existir, o GameMaker lê na memória temporária)
//file_delete("meu_save.ini");
ini_open("meu_save.ini");

global.carvao = ini_read_real("Recursos", "carvao", 0);
global.wood = ini_read_real("Recursos", "wood", 0);
global.iron = ini_read_real("Recursos", "iron", 0);
global.gold = ini_read_real("Recursos", "gold", 0);

// 4 upgrades
global.max_hp = ini_read_real("Upgrades", "max_hp", 10);
global.player_damage = ini_read_real("Upgrades", "dano", 5);
global.mine_speed = ini_read_real("Upgrades", "mine_speed", 1); // 1x velocidade base
global.mine_yield = ini_read_real("Upgrades", "mine_yield", 1); // 1 minério por batida

global.player_hp = global.max_hp;

ini_close();



// prefect the texturas pesadas dos personagens 256x256
sprite_prefetch(spr_player_walk);
sprite_prefetch(spr_player_pickaxe);
sprite_prefetch(spr_player_axe);
sprite_prefetch(spr_player_sword);
// fazer isso para os sprites dos inimigos também se eles forem pesados