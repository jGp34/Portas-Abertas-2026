// Abre o arquivo de save (se não existir, o GameMaker lê na memória temporária)
ini_open("meu_save.ini");

global.carvao = ini_read_real("Recursos", "carvao", 0);
global.wood = ini_read_real("Recursos", "wood", 0);
global.iron = ini_read_real("Recursos", "iron", 0);
global.gold = ini_read_real("Recursos", "gold", 0);

ini_close();

global.player_hp = 10;

// prefect the texturas pesadas dos personagens 256x256
sprite_prefetch(spr_walk);
sprite_prefetch(spr_pickaxe);
sprite_prefetch(spr_axe);
sprite_prefetch(spr_sword);
// fazer isso para os sprites dos inimigos também se eles forem pesados