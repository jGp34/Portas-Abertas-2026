depth = -bbox_bottom;
// =======================================================
// CHEATS / DEBUG (Teclas secretas)
// =======================================================
// F7 para MATAR O PLAYER (Testar tela de morte e save)
if (keyboard_check_pressed(vk_f7)) {
    global.player_hp = 0;
    show_debug_message("DEBUG: Player morto forçadamente!");
}
// F8 para colocar tudo no 999
if (keyboard_check_pressed(vk_f8)) {
    global.carvao = 9999;
    global.gold = 9999;
    global.iron = 9999;
    global.wood = 9999;
    global.souls = 9999;
    show_debug_message("DEBUG: Todos os recursos foram para 999!");
}

// F9 para zerar tudo
if (keyboard_check_pressed(vk_f9)) {
    global.carvao = 0;
    global.gold = 0;
    global.iron = 0;
    global.wood = 0;
    global.souls = 0;
    show_debug_message("DEBUG: Todos os recursos zerados!");
}

// F10 para HARD RESET
if (keyboard_check_pressed(vk_f10)) {
    if (file_exists("meu_save.ini")) {
        file_delete("meu_save.ini");
        show_debug_message("DEBUG: Arquivo meu_save.ini deletado com sucesso!");
    } else {
        show_debug_message("DEBUG: Nenhum save encontrado para deletar.");
    }
    show_debug_message("DEBUG: HARD RESET! Reiniciando o jogo...");
    game_restart();
}

// Spawna a Fada automaticamente se o jogador comprou ela e ela ainda não existe
if (global.fairy_unlocked == 1 && !instance_exists(obj_fairy)) {
    instance_create_layer(x, y, "Instances", obj_fairy);
}

if (global.burguer_unlocked == 1 && !instance_exists(obj_burguer)) {
    instance_create_layer(x, y, "Instances", obj_burguer);
}

// =======================================================
// 0. LÓGICA DE MORTE (Sempre checar primeiro)
// =======================================================
if (global.player_hp <= 0) {
    if (sprite_index != spr_player_death) {
        sprite_index = spr_player_death;
        image_index = 0;
        audio_play_sound(sfx_player_death, 1, false);
    }

    if (image_index >= image_number - 1) {
        image_speed = 0; 
        
        ini_open("meu_save.ini");
        ini_write_real("Recursos", "carvao", global.carvao);
        ini_write_real("Recursos", "gold", global.gold);
        ini_write_real("Recursos", "iron", global.iron);
        ini_write_real("Recursos", "wood", global.wood);
        ini_write_real("Recursos", "souls", global.souls);
        ini_close();
        
        room_goto(rm_upgrades);
    } else {
        image_speed = 1; // IMPORTANTE: Deixa a animação de morte rodar
    }
    
    // ANULA QUALQUER COMANDO DE TECLADO ENQUANTO MORTO!
    keyboard_clear(ord("E"));
    keyboard_clear(ord("Z"));
    
    exit; 
}

// =======================================================
// 1. CHECK IF WE ARE CURRENTLY ACTING
// =======================================================
var _is_acting = (sprite_index == spr_player_pickaxe || sprite_index == spr_player_axe || sprite_index == spr_player_sword);

// 2. GET MOVEMENT INPUTS
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = global.player_move_speed;

// -> CANCELAMENTO DA ANIMAÇÃO DE FERRAMENTAS PELO MOVIMENTO <-
if (_is_acting && (sprite_index == spr_player_pickaxe || sprite_index == spr_player_axe)) {
    if (_hinput != 0 || _vinput != 0) {
        _is_acting = false;           // Libera para andar na mesma hora
        action_sound_played = false;  // Reseta o som
        // Não precisamos mudar a sprite aqui porque o bloco logo abaixo já
        // vai detectar que o jogador tentou andar e vai mudar para spr_player_walk!
    }
}

if (!_is_acting) {
    // 3. AÇÃO INDEPENDENTE: Apenas a espada ("Z")
    if (keyboard_check_pressed(ord("Z"))) {
        sprite_index = spr_player_sword;
        image_index = 0;
        action_sound_played = false; // <--- FIX: Reseta o ataque assim que aperta o botão!
    } 
    // 4. MOVEMENT & WALKING ANIMATION
    else {
        if (_hinput != 0 || _vinput != 0) {
            var _dir = point_direction(0, 0, _hinput, _vinput);
            var _hspd = lengthdir_x(_move_speed, _dir);
            var _vspd = lengthdir_y(_move_speed, _dir);

            // Colisão Horizontal
            if (place_meeting(x + _hspd, y, obj_colision)) {
                while (!place_meeting(x + sign(_hspd), y, obj_colision)) {
                    x += sign(_hspd);
                }
                _hspd = 0;
            }
            x += _hspd;

            // Colisão Vertical
            if (place_meeting(x, y + _vspd, obj_colision)) {
                while (!place_meeting(x, y + sign(_vspd), obj_colision)) {
                    y += sign(_vspd);
                }
                _vspd = 0;
            }
            y += _vspd;
            
            sprite_index = spr_player_walk; 
        } else {
            sprite_index = spr_player_still; 
        }
    }
} else {
    // =======================================================
    // 5. LÓGICA DE AÇÕES (Espada, Picareta, Machado)
    // =======================================================
    
// ---> A. SONS DE FERRAMENTAS (70% da animação) <---
    if (sprite_index == spr_player_pickaxe || sprite_index == spr_player_axe) {
        
        if (image_index >= image_number * 0.7) {
            if (!action_sound_played) {
                action_sound_played = true; 
                
                if (sprite_index == spr_player_axe) {
                    audio_play_sound(sfx_player_chopping, 1, false);
                } 
                else if (sprite_index == spr_player_pickaxe) {
                    var _snd = audio_play_sound(sfx_player_mining, 1, false);
                    audio_sound_pitch(_snd, random_range(0.9, 1.1));
                }
            }
        } else {
            // SOLUÇÃO: Só reseta a trava quando a animação voltar para o começo (antes dos 70%)!
            action_sound_played = false;
        }
    }

// ---> B. DANO DA ESPADA <---
    if (sprite_index == spr_player_sword) {
        
        // A trava 'action_sound_played' garantirá que o som/dano só aconteça UMA VEZ por animação.
        if (image_index >= 10) { 
            
            if (!action_sound_played) {
                audio_play_sound(sfx_player_attack, 1, false);
                action_sound_played = true; // Usa a mesma trava para não repetir o som E o dano
                
                // === APLICAR DANO ===
                var _dist = 80 + (global.atk_area - 60);
                var _raio = global.atk_area;
                var _hx = x + lengthdir_x(_dist, (image_xscale > 0 ? 0 : 180));
                var _hy = y;

                var _hit_instances = ds_list_create();
                var _num = collision_circle_list(_hx, _hy, _raio, obj_enemy_parent, false, true, _hit_instances, false);

                for (var i = 0; i < _num; i++) {
                    var _inst = _hit_instances[| i];
                    
                    if (ds_list_find_index(hit_list, _inst) == -1) {
                        
                        // --- SISTEMA DE CRÍTICO ---
                        var _dano_final = global.player_damage; // Começa com o dano normal
                        var _foi_critico = false;
                        
                        // Sorteia um número de 0 a 100. Se cair abaixo da sua chance, é CRÍTICO!
                        if (random(100) < global.crit_chance) {
                            _dano_final = global.player_damage * global.crit_dano; // Crítico dá o DOBRO de dano!
                            _foi_critico = true;
                        }
                        
                        // Aplica o dano no inimigo
                        _inst.hp -= _dano_final; 
                        ds_list_add(hit_list, _inst);
                        
                        // Mostra no console se foi crítico ou não
                        if (_foi_critico) {
                            show_debug_message("CRÍTICO! Alvo: " + object_get_name(_inst.object_index) + " | Dano: " + string(_dano_final) + " | HP: " + string(_inst.hp));
                            audio_play_sound(sfx_player_crit, 1, false);
                        } else {
                            show_debug_message("HIT! Alvo: " + object_get_name(_inst.object_index) + " | Dano: " + string(_dano_final) + " | HP: " + string(_inst.hp));
                        }
                    }
                }
                ds_list_destroy(_hit_instances);
            }
        } else {
            // CORREÇÃO AQUI: O 'else' fica alinhado com o 'if (image_index >= 10)'
            action_sound_played = false;
        }
    }

    // ---> C. FINALIZAR AÇÃO E RESETAR ESTADOS <---
    if (image_index + image_speed >= image_number) {
        ds_list_clear(hit_list); 
        
        // Só interrompe a animação se for a espada, 
        // OU se for ferramenta e o jogador NÃO estiver segurando o "E".
        if (sprite_index == spr_player_sword || !keyboard_check(ord("E"))) {
            sprite_index = spr_player_still;
        }
    }
}

// =======================================================
// 6. FLIPPING
// =======================================================
if (_hinput != 0 && !_is_acting) {
    image_xscale = abs(image_xscale) * sign(_hinput); 
}

// 7. CONTROLE DA VELOCIDADE DA ANIMAÇÃO
if (sprite_index == spr_player_sword) {
    image_speed = global.atk_speed; // Acelera o ataque com base no upgrade!
} else if (sprite_index == spr_player_pickaxe || sprite_index == spr_player_axe) {
    image_speed = global.mine_speed; // Bônus: Aplica o upgrade de vel. de mineração aqui também!
} else {
    image_speed = 1; // Andar e Parado tocam na velocidade normal
}