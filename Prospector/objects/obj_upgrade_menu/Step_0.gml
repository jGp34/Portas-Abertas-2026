// Variável para rastrear se alguma compra foi feita neste frame
var _comprou_algo = false;

// ==========================================
// TROCAR DE PÁGINA
// ==========================================
if (keyboard_check_pressed(ord("Q"))) {
    menu_page = !menu_page; // Alterna entre 0 e 1
}

// ==========================================
// PÁGINA 0: UPGRADES DO JOGADOR
// ==========================================
if (menu_page == 0) {
    // 1. COMPRAR VIDA (+10)
    if (keyboard_check_pressed(ord("1")) && global.wood >= custo_vida) {
        global.wood -= custo_vida;
        global.max_hp = round(global.max_hp * 1.6);
        custo_vida = round(custo_vida * 1.5); 
        _comprou_algo = true; 
    }

    // 2. COMPRAR DANO (+2)
    if (keyboard_check_pressed(ord("2")) && global.iron >= custo_dano) {
        global.iron -= custo_dano;
        global.player_damage = round(global.player_damage * 1.3);
        custo_dano = round(custo_dano * 1.2);
        _comprou_algo = true;
    }

    // 3. COMPRAR VELOCIDADE DE MINERAR (+0.2)
    if (keyboard_check_pressed(ord("3")) && global.carvao >= custo_vel) {
        global.carvao -= custo_vel;
        global.mine_speed += 0.5;
        custo_vel = round(custo_vel * 1.4);
        _comprou_algo = true;
    }

    // 4. COMPRAR BÔNUS DE DROP (+1)
    if (keyboard_check_pressed(ord("4")) && global.gold >= custo_yield) {
        global.gold -= custo_yield;
        global.mine_yield = round(global.mine_yield * 1.7);
        custo_yield = round(custo_yield * 1.6);
        _comprou_algo = true;
    }

    // 5. COMPRAR VELOCIDADE DE ATAQUE (+0.1)
    if (keyboard_check_pressed(ord("5")) && global.gold >= custo_atk_speed) {
        global.gold -= custo_atk_speed;
        global.atk_speed += 0.5;
        custo_atk_speed = round(custo_atk_speed * 1.4);
        _comprou_algo = true;
    }

    // 6. COMPRAR VELOCIDADE DE MOVIMENTO (+0.5)
    if (keyboard_check_pressed(ord("6")) && global.carvao >= custo_move_speed) {
        global.carvao -= custo_move_speed;
        global.player_move_speed += 0.5;
        custo_move_speed = round(custo_move_speed * 1.4);
        _comprou_algo = true;
    }

    // 7. COMPRAR ÁREA DE ATAQUE (+10)
    if (keyboard_check_pressed(ord("7")) && global.iron >= custo_atk_area) {
        global.iron -= custo_atk_area;
        global.atk_area = round(global.atk_area * 1.4);
        custo_atk_area = round(custo_atk_area * 1.3);
        _comprou_algo = true;
    }

    // 8. COMPRAR CHANCE CRÍTICO (+5%)
    if (keyboard_check_pressed(ord("8")) && global.souls >= custo_critico) {
        global.souls -= custo_critico;
        global.crit_chance = round(global.crit_chance * 1.4); 
        custo_critico = round(custo_critico * 1.3); 
        _comprou_algo = true;
    }
}
// ==========================================
// PÁGINA 1: UPGRADES DE MAGIA E ALIADOS
// ==========================================
else if (menu_page == 1) {
    
    // ---> 1. DESBLOQUEAR FADA OU UPAR DANO <---
    if (keyboard_check_pressed(ord("1"))) {
        if (global.fairy_unlocked == 0 && global.souls >= custo_fada_unlock) {
            global.souls -= custo_fada_unlock;
            global.fairy_unlocked = 1;
            _comprou_algo = true;
        } 
        else if (global.fairy_unlocked == 1 && global.gold >= custo_fada_dano) {
            global.gold -= custo_fada_dano;
            global.fairy_damage += 2;
            custo_fada_dano += 15;
            _comprou_algo = true;
        }
    }

    // ---> 2. UPAR VEL. DE ATAQUE DA FADA (-10 frames) <---
    if (keyboard_check_pressed(ord("2")) && global.fairy_unlocked == 1) {
        if (global.gold >= custo_fada_vel && global.fairy_atk_speed > 10) {
            global.gold -= custo_fada_vel;
            global.fairy_atk_speed -= 10; 
            custo_fada_vel += 20;
            _comprou_algo = true;
        }
    }

    // ---> 3. UPAR RANGE DE VISÃO (+50 pixels) <---
    if (keyboard_check_pressed(ord("3")) && global.fairy_unlocked == 1) {
        if (global.iron >= custo_fada_range) {
            global.iron -= custo_fada_range;
            global.fairy_vision += 50; 
            custo_fada_range += 15;
            _comprou_algo = true;
        }
    }

    // ==========================================
    // UPGRADES DO HAMBÚRGUER (Botões 4 e 5)
    // ==========================================

    // ---> 4. DESBLOQUEAR HAMBÚRGUER OU UPAR CURA (+2 HP) <---
    if (keyboard_check_pressed(ord("4"))) {
        if (global.burguer_unlocked == 0 && global.souls >= custo_burguer_unlock) {
            global.souls -= custo_burguer_unlock;
            global.burguer_unlocked = 1;
            _comprou_algo = true;
        } 
        else if (global.burguer_unlocked == 1 && global.gold >= custo_burguer_heal) {
            global.gold -= custo_burguer_heal;
            global.burguer_heal_amount += 2;
            custo_burguer_heal += 15;
            _comprou_algo = true;
        }
    }

    // ---> 5. UPAR VEL. DE CURA DO HAMBÚRGUER (-15 frames) <---
    if (keyboard_check_pressed(ord("5")) && global.burguer_unlocked == 1) {
        if (global.iron >= custo_burguer_speed && global.burguer_heal_speed > 30) {
            global.iron -= custo_burguer_speed;
            global.burguer_heal_speed -= 15; 
            custo_burguer_speed += 20;
            _comprou_algo = true;
        }
    }
} // <--- A CHAVE QUE FECHA A PÁGINA 1 FICA AQUI AGORA!

// ==========================================
// TOCA O SOM SE COMPROU ALGO
// ==========================================
if (_comprou_algo) {
    audio_play_sound(sfx_buying, 1, false);
}

// ==========================================
// 9. RESSUSCITAR E SALVAR
// ==========================================
if (keyboard_check_pressed(vk_space)) {
    ini_open("meu_save.ini");
    
    // --- SALVA TODOS OS UPGRADES ---
    ini_write_real("Upgrades", "max_hp", global.max_hp);
    ini_write_real("Upgrades", "dano", global.player_damage);
    ini_write_real("Upgrades", "mine_speed", global.mine_speed);
    ini_write_real("Upgrades", "mine_yield", global.mine_yield);
    ini_write_real("Upgrades", "atk_speed", global.atk_speed);
    ini_write_real("Upgrades", "move_speed", global.player_move_speed);
    ini_write_real("Upgrades", "atk_area", global.atk_area);
    ini_write_real("Upgrades", "crit_chance", global.crit_chance); 
    ini_write_real("Upgrades", "fairy_unlocked", global.fairy_unlocked); 
    ini_write_real("Upgrades", "fairy_dano", global.fairy_damage); 
    ini_write_real("Upgrades", "fairy_atk", global.fairy_atk_speed); 
    ini_write_real("Upgrades", "fairy_vision", global.fairy_vision);
    ini_write_real("Upgrades", "burguer_unlocked", global.burguer_unlocked); 
    ini_write_real("Upgrades", "burguer_heal_amount", global.burguer_heal_amount); 
    ini_write_real("Upgrades", "burguer_heal_speed", global.burguer_heal_speed);
    
    // --- SALVA TODOS OS CUSTOS ---
    ini_write_real("Custos", "custo_vida", custo_vida);
    ini_write_real("Custos", "custo_dano", custo_dano);
    ini_write_real("Custos", "custo_vel", custo_vel);
    ini_write_real("Custos", "custo_yield", custo_yield);
    ini_write_real("Custos", "custo_atk_speed", custo_atk_speed);
    ini_write_real("Custos", "custo_move_speed", custo_move_speed);
    ini_write_real("Custos", "custo_atk_area", custo_atk_area);
    ini_write_real("Custos", "custo_critico", custo_critico); 
    ini_write_real("Custos", "custo_fada_unlock", custo_fada_unlock); 
    ini_write_real("Custos", "custo_fada_dano", custo_fada_dano); 
    ini_write_real("Custos", "custo_fada_vel", custo_fada_vel);
    ini_write_real("Custos", "custo_fada_range", custo_fada_range);
    ini_write_real("Custos", "custo_burguer_unlock", custo_burguer_unlock); 
    ini_write_real("Custos", "custo_burguer_heal", custo_burguer_heal); 
    ini_write_real("Custos", "custo_burguer_speed", custo_burguer_speed);

    // --- SALVA TODOS OS RECURSOS ---
    ini_write_real("Recursos", "wood", global.wood);
    ini_write_real("Recursos", "iron", global.iron);
    ini_write_real("Recursos", "carvao", global.carvao);
    ini_write_real("Recursos", "gold", global.gold);
    ini_write_real("Recursos", "souls", global.souls); 
    
    ini_close();
    
    // Restaura a vida para o novo limite e volta pro jogo
    global.player_hp = global.max_hp;
    room_goto(rm_game); 
}