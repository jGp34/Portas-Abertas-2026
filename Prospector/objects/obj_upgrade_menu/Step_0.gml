var _comprou_algo = false;
tempo_menu++; // Relógio interno para as animações da interface

// TROCAR DE PÁGINA
if (keyboard_check_pressed(ord("Q"))) {
    menu_page = !menu_page; 
}

// FULLSCREEN
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);

    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) {
            surface_resize(application_surface, display_get_width(), display_get_height());
        } else {
            surface_resize(application_surface, window_get_width(), window_get_height());
        }
    });
}

// ==========================================
// PÁGINA 0: UPGRADES DO JOGADOR
// ==========================================
if (menu_page == 0) {
    if (keyboard_check_pressed(ord("1")) && global.wood >= custo_vida) {
        global.wood -= custo_vida;
        global.max_hp = round(global.max_hp * 1.6);
        custo_vida = round(custo_vida * 1.4); 
        _comprou_algo = true; 
    }
    if (keyboard_check_pressed(ord("2")) && global.carvao >= custo_dano) {
        global.carvao -= custo_dano;
        global.player_damage = round(global.player_damage * 1.6);
        custo_dano = round(custo_dano * 1.4);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("3")) && global.iron >= custo_vel) {
        global.iron -= custo_vel;
        global.mine_speed += 0.5;
        custo_vel = round(custo_vel * 1.5);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("4")) && global.gold >= custo_yield) {
        global.gold -= custo_yield;
        global.mine_yield += 1;
        custo_yield = round(custo_yield * 1.5);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("5")) && global.gold >= custo_atk_speed) {
        global.gold -= custo_atk_speed;
        global.atk_speed += 0.5;
        custo_atk_speed = round(custo_atk_speed * 1.5);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("6")) && global.carvao >= custo_move_speed) {
        global.carvao -= custo_move_speed;
        global.player_move_speed += 0.5;
        custo_move_speed = round(custo_move_speed * 1.4);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("7")) && global.iron >= custo_atk_area) {
        global.iron -= custo_atk_area;
        global.atk_area = round(global.atk_area * 1.3);
        custo_atk_area = round(custo_atk_area * 1.2);
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("8")) && global.souls >= custo_critico) {
        global.souls -= custo_critico;
        global.crit_chance += 5; 
        custo_critico = round(custo_critico * 1.3); 
        _comprou_algo = true;
    }
    if (keyboard_check_pressed(ord("9")) && global.souls >= custo_crit_dano) {
        global.souls -= custo_crit_dano;
        global.crit_dano += 0.5; 
        custo_crit_dano = round(custo_crit_dano * 1.4); 
        _comprou_algo = true;
    }
}
// ==========================================
// PÁGINA 1: MAGIA E ALIADOS
// ==========================================
else if (menu_page == 1) {
    if (keyboard_check_pressed(ord("1"))) {
        if (global.fairy_unlocked == 0 && global.souls >= custo_fada_unlock) {
            global.souls -= custo_fada_unlock;
            global.fairy_unlocked = 1;
            _comprou_algo = true;
        } 
        else if (global.fairy_unlocked == 1 && global.souls >= custo_fada_dano) {
            global.souls -= custo_fada_dano; 
            global.fairy_damage += 2;
            custo_fada_dano = round(custo_fada_dano * 1.5); 
            _comprou_algo = true;
        }
    }
    if (keyboard_check_pressed(ord("2")) && global.fairy_unlocked == 1) {
        if (global.gold >= custo_fada_vel && global.fairy_atk_speed > 10) {
            global.gold -= custo_fada_vel;
            global.fairy_atk_speed -= 10; 
            custo_fada_vel = round(custo_fada_vel * 1.5); 
            _comprou_algo = true;
        }
    }
    if (keyboard_check_pressed(ord("3")) && global.fairy_unlocked == 1) {
        if (global.iron >= custo_fada_range) {
            global.iron -= custo_fada_range;
            global.fairy_vision += 50; 
            custo_fada_range = round(custo_fada_range * 1.4); 
            _comprou_algo = true;
        }
    }

    if (keyboard_check_pressed(ord("4"))) {
        if (global.burguer_unlocked == 0 && global.souls >= custo_burguer_unlock) {
            global.souls -= custo_burguer_unlock;
            global.burguer_unlocked = 1;
            _comprou_algo = true;
        } 
        else if (global.burguer_unlocked == 1 && global.gold >= custo_burguer_heal) {
            global.gold -= custo_burguer_heal;
            global.burguer_heal_amount += 2;
            custo_burguer_heal = round(custo_burguer_heal * 1.5); 
            _comprou_algo = true;
        }
    }
    if (keyboard_check_pressed(ord("5")) && global.burguer_unlocked == 1) {
        if (global.iron >= custo_burguer_speed && global.burguer_heal_speed > 30) {
            global.iron -= custo_burguer_speed;
            global.burguer_heal_speed -= 15; 
            custo_burguer_speed = round(custo_burguer_speed * 1.5); 
            _comprou_algo = true;
        }
    }
} 

// TOCA O SOM E ANIMA A DEUSA
if (_comprou_algo) {
    audio_play_sound(sfx_buying, 1, false);
    if (goddess_sprite != spr_goddess_thanks) {
        goddess_sprite = spr_goddess_thanks;
        goddess_frame = 0;
        goddess_spd = sprite_get_speed(spr_goddess_thanks) / game_get_speed(gamespeed_fps);
    }
    
    // Pequeno feedback de "shake" na tela (opcional)
    camera_set_view_pos(view_camera[0], random_range(-2, 2), random_range(-2, 2));
}

// Retorna a câmera pro lugar caso ela trema
camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), 0, 0.2), lerp(camera_get_view_y(view_camera[0]), 0, 0.2));

// CONTROLE DE ANIMAÇÃO DA DEUSA
goddess_frame += goddess_spd; 

if (goddess_sprite == spr_goddess_thanks) {
    if (goddess_frame >= sprite_get_number(spr_goddess_thanks)) {
        goddess_sprite = spr_goddess_still;
        goddess_frame = 0;
        goddess_spd = sprite_get_speed(spr_goddess_still) / game_get_speed(gamespeed_fps);
    }
} else {
    if (goddess_frame >= sprite_get_number(spr_goddess_still)) {
        goddess_frame = 0;
    }
}

// SALVAR E SAIR
if (keyboard_check_pressed(vk_space)) {
    ini_open("meu_save.ini");
    // [Seu código de salvar idêntico, omiti pra não alongar, MANTENHA AQUI O CÓDIGO DO ESPAÇO!]
    
    ini_write_real("Upgrades", "max_hp", global.max_hp);
    ini_write_real("Upgrades", "dano", global.player_damage);
    ini_write_real("Upgrades", "mine_speed", global.mine_speed);
    ini_write_real("Upgrades", "mine_yield", global.mine_yield);
    ini_write_real("Upgrades", "atk_speed", global.atk_speed);
    ini_write_real("Upgrades", "move_speed", global.player_move_speed);
    ini_write_real("Upgrades", "atk_area", global.atk_area);
    ini_write_real("Upgrades", "crit_chance", global.crit_chance); 
    ini_write_real("Upgrades", "crit_dano", global.crit_dano); 
    
    ini_write_real("Upgrades", "fairy_unlocked", global.fairy_unlocked); 
    ini_write_real("Upgrades", "fairy_dano", global.fairy_damage); 
    ini_write_real("Upgrades", "fairy_atk", global.fairy_atk_speed); 
    ini_write_real("Upgrades", "fairy_vision", global.fairy_vision);
    ini_write_real("Upgrades", "burguer_unlocked", global.burguer_unlocked); 
    ini_write_real("Upgrades", "burguer_heal_amount", global.burguer_heal_amount); 
    ini_write_real("Upgrades", "burguer_heal_speed", global.burguer_heal_speed);
    
    ini_write_real("Custos", "custo_vida", custo_vida);
    ini_write_real("Custos", "custo_dano", custo_dano);
    ini_write_real("Custos", "custo_vel", custo_vel);
    ini_write_real("Custos", "custo_yield", custo_yield);
    ini_write_real("Custos", "custo_atk_speed", custo_atk_speed);
    ini_write_real("Custos", "custo_move_speed", custo_move_speed);
    ini_write_real("Custos", "custo_atk_area", custo_atk_area);
    ini_write_real("Custos", "custo_critico", custo_critico); 
    ini_write_real("Custos", "custo_crit_dano", custo_crit_dano); 
    
    ini_write_real("Custos", "custo_fada_unlock", custo_fada_unlock); 
    ini_write_real("Custos", "custo_fada_dano", custo_fada_dano); 
    ini_write_real("Custos", "custo_fada_vel", custo_fada_vel);
    ini_write_real("Custos", "custo_fada_range", custo_fada_range);
    ini_write_real("Custos", "custo_burguer_unlock", custo_burguer_unlock); 
    ini_write_real("Custos", "custo_burguer_heal", custo_burguer_heal); 
    ini_write_real("Custos", "custo_burguer_speed", custo_burguer_speed);

    ini_write_real("Recursos", "wood", global.wood);
    ini_write_real("Recursos", "iron", global.iron);
    ini_write_real("Recursos", "carvao", global.carvao);
    ini_write_real("Recursos", "gold", global.gold);
    ini_write_real("Recursos", "souls", global.souls); 
    
    ini_close();
    
    global.player_hp = global.max_hp;
    room_goto(rm_game); 
}