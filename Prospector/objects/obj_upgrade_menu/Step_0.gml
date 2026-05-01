// 1. COMPRAR VIDA (+10)
if (keyboard_check_pressed(ord("1")) && global.wood >= custo_vida) {
    global.wood -= custo_vida;
    global.max_hp += 10;
    custo_vida += 25; // Aumenta o preço para o próximo nível
}

// 2. COMPRAR DANO (+2)
if (keyboard_check_pressed(ord("2")) && global.iron >= custo_dano) {
    global.iron -= custo_dano;
    global.player_damage += 2;
    custo_dano += 15;
}

// 3. COMPRAR VELOCIDADE (+0.2)
if (keyboard_check_pressed(ord("3")) && global.carvao >= custo_vel) {
    global.carvao -= custo_vel;
    global.mine_speed += 0.2;
    custo_vel += 20;
}

// 4. COMPRAR BÔNUS DE DROP (+1)
if (keyboard_check_pressed(ord("4")) && global.gold >= custo_yield) {
    global.gold -= custo_yield;
    global.mine_yield += 1;
    custo_yield += 50;
}

// 5. RESSUSCITAR
if (keyboard_check_pressed(vk_space)) {
    // Grava tudo o que foi gasto e comprado
    ini_open("meu_save.ini");
    
    // Salva os upgrades
    ini_write_real("Upgrades", "max_hp", global.max_hp);
    ini_write_real("Upgrades", "dano", global.player_damage);
    ini_write_real("Upgrades", "mine_speed", global.mine_speed);
    ini_write_real("Upgrades", "mine_yield", global.mine_yield);
    
    // Salva o "troco" (minérios que sobraram)
    ini_write_real("Recursos", "wood", global.wood);
    ini_write_real("Recursos", "iron", global.iron);
    ini_write_real("Recursos", "carvao", global.carvao);
    ini_write_real("Recursos", "gold", global.gold);
    
    ini_close();
    
    // Cura o jogador para o novo máximo de vida e manda pro jogo
    global.player_hp = global.max_hp;
    room_goto(Room1); // Coloque aqui o nome exato da sua sala principal do jogo
}