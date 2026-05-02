// 1. COMPRAR VIDA (+10)
if (keyboard_check_pressed(ord("1")) && global.wood >= custo_vida) {
    global.wood -= custo_vida;
    global.max_hp += 10;
    custo_vida += 25; 
}

// 2. COMPRAR DANO (+2)
if (keyboard_check_pressed(ord("2")) && global.iron >= custo_dano) {
    global.iron -= custo_dano;
    global.player_damage += 2;
    custo_dano += 15;
}

// 3. COMPRAR VELOCIDADE DE MINERAR (+0.2)
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

// ---> 5. COMPRAR VELOCIDADE DE ATAQUE (+0.1 = 10% mais rápido)
if (keyboard_check_pressed(ord("5")) && global.gold >= custo_atk_speed) {
    global.gold -= custo_atk_speed;
    global.atk_speed += 0.1;
    custo_atk_speed += 20;
}

// ---> 6. COMPRAR VELOCIDADE DE MOVIMENTO (+0.5)
if (keyboard_check_pressed(ord("6")) && global.carvao >= custo_move_speed) {
    global.carvao -= custo_move_speed;
    global.player_move_speed += 0.5;
    custo_move_speed += 15;
}

// ---> 7. COMPRAR ÁREA DE ATAQUE (+10 pixels de raio)
if (keyboard_check_pressed(ord("7")) && global.iron >= custo_atk_area) {
    global.iron -= custo_atk_area;
    global.atk_area += 10;
    custo_atk_area += 15;
}

// 8. RESSUSCITAR (Salvar)
if (keyboard_check_pressed(vk_space)) {
    ini_open("meu_save.ini");
    
    // Salva os upgrades antigos e os NOVOS
    ini_write_real("Upgrades", "max_hp", global.max_hp);
    ini_write_real("Upgrades", "dano", global.player_damage);
    ini_write_real("Upgrades", "mine_speed", global.mine_speed);
    ini_write_real("Upgrades", "mine_yield", global.mine_yield);
    ini_write_real("Upgrades", "atk_speed", global.atk_speed);
    ini_write_real("Upgrades", "move_speed", global.player_move_speed);
    ini_write_real("Upgrades", "atk_area", global.atk_area);
    
    // Salva os custos atuais (incluindo os novos)
    ini_write_real("Custos", "custo_vida", custo_vida);
    ini_write_real("Custos", "custo_dano", custo_dano);
    ini_write_real("Custos", "custo_vel", custo_vel);
    ini_write_real("Custos", "custo_yield", custo_yield);
    ini_write_real("Custos", "custo_atk_speed", custo_atk_speed);
    ini_write_real("Custos", "custo_move_speed", custo_move_speed);
    ini_write_real("Custos", "custo_atk_area", custo_atk_area);
    
    // Salva os recursos
    ini_write_real("Recursos", "wood", global.wood);
    ini_write_real("Recursos", "iron", global.iron);
    ini_write_real("Recursos", "carvao", global.carvao);
    ini_write_real("Recursos", "gold", global.gold);
    
    ini_close();
    
    global.player_hp = global.max_hp;
    room_goto(Room1); 
}