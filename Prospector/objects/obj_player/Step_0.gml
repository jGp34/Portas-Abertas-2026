// =======================================================
// 0. LÓGICA DE MORTE (Sempre checar primeiro)
// =======================================================
if (global.player_hp <= 0) {
    // Se a animação de morte ainda não foi definida, mude para ela
    if (sprite_index != spr_player_death) {
        sprite_index = spr_player_death;
        image_index = 0; // Começa do primeiro frame
    }

    // Verifica se a animação chegou no último frame
    if (image_index >= image_number - 1) {
        // Pausa no último frame (opcional, evita loop antes do reset)
        image_speed = 0; 
        
        // O JOÃO DESATIVOU O ALARME E COLOCOU O SAVE:
        ini_open("meu_save.ini");
        
        ini_write_real("Recursos", "carvao", global.carvao);
        ini_write_real("Recursos", "gold", global.gold);
        ini_write_real("Recursos", "iron", global.iron);
        ini_write_real("Recursos", "wood", global.wood);
        
        ini_close();
        
        room_restart();
    }
    
    // O comando 'exit' impede que o código abaixo (movimento/ataque) rode se o player estiver morto
    exit; 
}


// =======================================================
// 1. CHECK IF WE ARE CURRENTLY ACTING
// =======================================================
var _is_acting = (sprite_index == spr_player_pickaxe || sprite_index == spr_player_axe || sprite_index == spr_player_sword);

// 2. GET MOVEMENT INPUTS
var _hinput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _vinput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _move_speed = 4;

if (!_is_acting) {
    // 3. AÇÃO INDEPENDENTE: Apenas a espada ("Z")
    if (keyboard_check_pressed(ord("Z"))) {
        sprite_index = spr_player_sword;
        image_index = 0;
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
    // 5. LÓGICA DE DANO
    if (sprite_index == spr_player_sword) {
        
        // Frames 11 ao 16 (índices 10 a 15)
        if (image_index >= 10 && image_index <= 15) { 
            
            var _dist = 80; 
            var _raio = 60;
            var _hx = x + lengthdir_x(_dist, (image_xscale > 0 ? 0 : 180));
            var _hy = y;

            var _hit_instances = ds_list_create();
            // Procuramos o PAI de todos os inimigos
            var _num = collision_circle_list(_hx, _hy, _raio, obj_enemy_parent, false, true, _hit_instances, false);

            for (var i = 0; i < _num; i++) {
                var _inst = _hit_instances[| i];
                
                // CHECAGEM CRÍTICA: O inimigo está na lista?
                if (ds_list_find_index(hit_list, _inst) == -1) {
                    _inst.hp -= player_damage;
                    ds_list_add(hit_list, _inst);
                    
                    // MENSAGEM NO TERMINAL
                    show_debug_message("HIT! Alvo: " + object_get_name(_inst.object_index) + " | HP: " + string(_inst.hp));
                }
            }
            ds_list_destroy(_hit_instances);
        }
    }

    // FINALIZAR AÇÃO (E resetar o estado)
    if (image_index >= image_number - 1) {
        sprite_index = spr_player_still;
        ds_list_clear(hit_list); // LIMPEZA EXTRA POR SEGURANÇA
        show_debug_message("Animação acabou. Lista limpa para o próximo golpe.");
    }
}

// 6. FLIPPING
if (_hinput != 0) {
    image_xscale = abs(image_xscale) * sign(_hinput); 
}