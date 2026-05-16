var _comprou_algo = false;
var _falhou_compra = false; // Controla se o jogador tentou comprar sem dinheiro
tempo_menu++; // Relógio interno para as animações da interface

// TROCAR DE PÁGINA
if (keyboard_check_pressed(ord("Q"))) {
    menu_page = !menu_page; 
    audio_play_sound(sfx_change_page, 1, false); // Som de trocar página
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
    if (keyboard_check_pressed(ord("1"))) {
        if (global.max_hp < 220 || global.boss_morto) {
            if (global.wood >= custo_vida) {
                global.wood -= custo_vida;
                global.max_hp = round(global.max_hp * 1.4);
                custo_vida = round(custo_vida * 1.4); 
                _comprou_algo = true; 
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; } // <--- Limite alcançado
    }
    if (keyboard_check_pressed(ord("2"))) {
        if (global.player_damage < 100 || global.boss_morto) {
            if (global.carvao >= custo_dano) {
                global.carvao -= custo_dano;
                global.player_damage = round(global.player_damage * 1.4);
                custo_dano = round(custo_dano * 1.4);
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; }
    }
    if (keyboard_check_pressed(ord("3"))) {
        // Sem cap definido
        if (global.iron >= custo_vel) {
            global.iron -= custo_vel;
            global.mine_speed += 0.5;
            custo_vel = round(custo_vel * 1.5);
            _comprou_algo = true;
        } else { _falhou_compra = true; }
    }
    if (keyboard_check_pressed(ord("4"))) {
        // Sem cap definido
        if (global.gold >= custo_yield) {
            global.gold -= custo_yield;
            global.mine_yield += 1;
            custo_yield = round(custo_yield * 1.5);
            _comprou_algo = true;
        } else { _falhou_compra = true; }
    }
    if (keyboard_check_pressed(ord("5"))) {
        if (global.atk_speed < 3 || global.boss_morto) {
            if (global.gold >= custo_atk_speed) {
                global.gold -= custo_atk_speed;
                global.atk_speed += 0.5;
                custo_atk_speed = round(custo_atk_speed * 1.5);
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; }
    }
	if (keyboard_check_pressed(ord("6"))) {
	        // ---> NOVO: Limita a velocidade em 8 antes do boss morrer <---
	        if (global.player_move_speed < 8 || global.boss_morto) {
	            if (global.carvao >= custo_move_speed) {
	                global.carvao -= custo_move_speed;
	                global.player_move_speed += 0.5;
	                custo_move_speed = round(custo_move_speed * 1.4);
	                _comprou_algo = true;
	            } else { _falhou_compra = true; }
	        } else { _falhou_compra = true; } // <--- Limite alcançado
	}
    if (keyboard_check_pressed(ord("7"))) {
        if (global.atk_area < 90 || global.boss_morto) {
            if (global.iron >= custo_atk_area) {
                global.iron -= custo_atk_area;
                global.atk_area = round(global.atk_area * 1.2);
                custo_atk_area = round(custo_atk_area * 1.2);
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; }
    }
    if (keyboard_check_pressed(ord("8"))) {
        if (global.crit_chance < 30 || global.boss_morto) {
            if (global.souls >= custo_critico) {
                global.souls -= custo_critico;
                global.crit_chance += 5; 
                custo_critico = round(custo_critico * 1.3); 
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; }
    }
    if (keyboard_check_pressed(ord("9"))) {
        if (global.crit_dano < 4 || global.boss_morto) {
            if (global.souls >= custo_crit_dano) {
                global.souls -= custo_crit_dano;
                global.crit_dano += 0.5; 
                custo_crit_dano = round(custo_crit_dano * 1.4); 
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } else { _falhou_compra = true; }
    }
}
// ==========================================
// PÁGINA 1: MAGIA E ALIADOS
// ==========================================
else if (menu_page == 1) {
    if (keyboard_check_pressed(ord("1"))) {
        if (global.fairy_unlocked == 0) {
            if (global.souls >= custo_fada_unlock) {
                global.souls -= custo_fada_unlock;
                global.fairy_unlocked = 1;
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } 
        else if (global.fairy_unlocked == 1) {
            if (global.fairy_damage < 30 || global.boss_morto) {
                if (global.souls >= custo_fada_dano) {
                    global.souls -= custo_fada_dano; 
                    global.fairy_damage += 2;
                    custo_fada_dano = round(custo_fada_dano * 1.5); 
                    _comprou_algo = true;
                } else { _falhou_compra = true; }
            } else { _falhou_compra = true; }
        }
    }
    if (keyboard_check_pressed(ord("2"))) {
        if (global.fairy_unlocked == 1) {
            if (global.fairy_atk_speed > 50 || global.boss_morto) {
                if (global.gold >= custo_fada_vel && global.fairy_atk_speed > 10) {
                    global.gold -= custo_fada_vel;
                    global.fairy_atk_speed -= 10; 
                    custo_fada_vel = round(custo_fada_vel * 1.5); 
                    _comprou_algo = true;
                } else { _falhou_compra = true; }
            } else { _falhou_compra = true; }
        }
    }
    if (keyboard_check_pressed(ord("3"))) {
        if (global.fairy_vision < 400 || global.boss_morto) {
            if (global.fairy_unlocked == 1) {
                if (global.iron >= custo_fada_range) {
                    global.iron -= custo_fada_range;
                    global.fairy_vision += 50; 
                    custo_fada_range = round(custo_fada_range * 1.4); 
                    _comprou_algo = true;
                } else { _falhou_compra = true; }
            }
        } else { _falhou_compra = true; }
    }

    if (keyboard_check_pressed(ord("4"))) {
        if (global.burguer_unlocked == 0) {
            if (global.souls >= custo_burguer_unlock) {
                global.souls -= custo_burguer_unlock;
                global.burguer_unlocked = 1;
                _comprou_algo = true;
            } else { _falhou_compra = true; }
        } 
        else if (global.burguer_unlocked == 1) {
            if (global.burguer_heal_amount < 30 || global.boss_morto) {
                if (global.gold >= custo_burguer_heal) {
                    global.gold -= custo_burguer_heal;
                    global.burguer_heal_amount += 2;
                    custo_burguer_heal = round(custo_burguer_heal * 1.5); 
                    _comprou_algo = true;
                } else { _falhou_compra = true; }
            } else { _falhou_compra = true; }
        }
    }
    if (keyboard_check_pressed(ord("5"))) {
        if (global.burguer_unlocked == 1) {
            if (global.burguer_heal_speed > 350 || global.boss_morto) {
                if (global.iron >= custo_burguer_speed && global.burguer_heal_speed > 30) {
                    global.iron -= custo_burguer_speed;
                    global.burguer_heal_speed -= 15; 
                    custo_burguer_speed = round(custo_burguer_speed * 1.5); 
                    _comprou_algo = true;
                } else { _falhou_compra = true; }
            } else { _falhou_compra = true; }
        }
    }
} 

// ==========================================
// TOCA O SOM, TREME A TELA E SALVA
// ==========================================
if (_comprou_algo) {
    audio_play_sound(sfx_buying, 1, false);
    camera_set_view_pos(view_camera[0], random_range(-2, 2), random_range(-2, 2));
    
    // ---> SALVA O JOGO AUTOMATICAMENTE APÓS COMPRAR <---
    salvar_jogo();
} 
else if (_falhou_compra) {
    audio_play_sound(sfx_poor, 1, false);
}

// Retorna a câmera pro lugar caso ela trema
camera_set_view_pos(view_camera[0], lerp(camera_get_view_x(view_camera[0]), 0, 0.2), lerp(camera_get_view_y(view_camera[0]), 0, 0.2));


// ==========================================
// CONTROLE DE ANIMAÇÃO DA DEUSA (Não se cancelam)
// ==========================================
// Só aceita mudar de animação se ela estiver parada
if (goddess_sprite == spr_goddess_still) {
    if (_comprou_algo) {
        goddess_sprite = spr_goddess_thanks;
        goddess_frame = 0;
        goddess_spd = sprite_get_speed(spr_goddess_thanks) / game_get_speed(gamespeed_fps);
    } 
    else if (_falhou_compra) {
        goddess_sprite = spr_goddess_no;
        goddess_frame = 0;
        goddess_spd = sprite_get_speed(spr_goddess_no) / game_get_speed(gamespeed_fps);
    }
}

goddess_frame += goddess_spd; 

// Controlador de animação para resetar quando acabar
if (goddess_sprite == spr_goddess_thanks || goddess_sprite == spr_goddess_no) {
    if (goddess_frame >= sprite_get_number(goddess_sprite)) {
        goddess_sprite = spr_goddess_still;
        goddess_frame = 0;
        goddess_spd = sprite_get_speed(spr_goddess_still) / game_get_speed(gamespeed_fps);
    }
} else {
    if (goddess_frame >= sprite_get_number(spr_goddess_still)) {
        goddess_frame = 0;
    }
}

// ==========================================
// SALVAR E SAIR DO MENU
// ==========================================
if (keyboard_check_pressed(vk_space)) {
    // Salva pela última vez por garantia antes de trocar de room
    salvar_jogo();
    
    // ---> CORREÇÃO AQUI: Para a música da loja ao sair! <---
    audio_stop_sound(msc_menu); 
    
    global.player_hp = global.max_hp;
    room_goto(rm_game); 
}