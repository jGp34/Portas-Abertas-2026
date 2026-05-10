depth = -bbox_bottom;
if (!instance_exists(obj_player)) exit;

// ==========================================
// 1. LÓGICA DE INVULNERABILIDADE NA TRANSFORMAÇÃO
// ==========================================
if (state == "transform") {
    hp = max_hp / 2; 
}

// ==========================================
// 2. LÓGICA DE MORTE
// ==========================================
if (hp <= 0) {
    if (state != "death") {
        state = "death";
        sprite_index = spr_knight_death;
        image_index = 0;
        show_debug_message("Boss derrotado! Morrendo...");
    }
    
    if (image_index >= image_number - 1) {
        instance_destroy();
    }
    exit; 
}

// ==========================================
// 3. TRANSIÇÃO PARA A FASE 2 (50% de Vida)
// ==========================================
if (hp <= max_hp / 2 && phase == 1) {
    phase = 2;
    state = "transform";
    sprite_index = spr_knight_transform;
    image_index = 0;
    chase_timer = 0; // Garante que o cronômetro comece zerado na fase 2
    alarm[0] = -1; 
    show_debug_message("FASE 2 INICIADA!");
}

var _folga = 8;
var _meu_chao = bbox_bottom;
var _player_chao = obj_player.bbox_bottom;

// ==========================================
// 4. MÁQUINA DE ESTADOS DO BOSS
// ==========================================
switch (state) {
    
    // ------------------------------------------
    // ESTADOS DE INTRODUÇÃO
    // ------------------------------------------
    case "intro_walk":
        sprite_index = spr_knight_walk;
        
        if (hp < max_hp || place_meeting(x, y, obj_player)) {
            state = "chase";
            chase_timer = 0;
            break; 
        }
        
        if (target_wait != noone) {
            var _dist_wait = point_distance(x, y, target_wait.x, target_wait.y);
            if (_dist_wait > 3) {
                var _dir = point_direction(x, y, target_wait.x, target_wait.y);
                x += lengthdir_x(move_spd, _dir);
                y += lengthdir_y(move_spd, _dir);
                if (abs(lengthdir_x(move_spd, _dir)) > 0.1) {
                    image_xscale = sign(lengthdir_x(move_spd, _dir)) * base_scale;
                }
            } else {
                state = "intro_wait";
            }
        } else {
            state = "intro_wait";
        }
        break;
        
    case "intro_wait":
        sprite_index = spr_knight_still;
        if (hp < max_hp || place_meeting(x, y, obj_player)) {
            state = "chase";
            chase_timer = 0;
        }
        break;

    // ------------------------------------------
    // FASE 1: COMBATE E DESCANSOS
    // ------------------------------------------
    case "chase":
        sprite_index = spr_knight_walk;
        chase_timer++; 
        
        var _dist_player = point_distance(x, _meu_chao, obj_player.x, _player_chao);
        
        if (abs(obj_player.x - x) > 1) {
            image_xscale = sign(obj_player.x - x) * base_scale;
        }
        
        if (_dist_player <= attack_dist || chase_timer > (attack_cooldown * 3)) {
            chase_timer = 0; 
            
            // Avalia se o jogador está mais vertical ou horizontal
            var _dist_x = abs(obj_player.x - x);
            var _dist_y = abs(obj_player.y - y);
            
            if (_dist_y > _dist_x) {
                state = "attack_beam";
                sprite_index = spr_knight_beam;
            } else {
                state = "attack_slash";
                sprite_index = spr_knight_slash;
            }
            
            image_index = 0;
            attack_hit = false;
        } else {
            var _dir = point_direction(x, _meu_chao, obj_player.x, _player_chao);
            var _hspd = lengthdir_x(move_spd, _dir);
            var _vspd = lengthdir_y(move_spd, _dir);
            
            if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
                while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
                _hspd = 0;
            }
            x += _hspd;
        
            if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
                while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
                _vspd = 0;
            }
            y += _vspd;
        }
        break;

    // ------------------------------------------
    // FASE 1: ATAQUES ESPECÍFICOS
    // ------------------------------------------
    case "attack_beam":
        if (image_index >= image_number * 0.25) && (!attack_hit) {
            attack_hit = true; 
            
            var _beam = instance_create_layer(x, bbox_bottom - 10, "Instances", obj_projectile_knight_beam);
            _beam.damage = damage; 
            show_debug_message("Preparando Raio Arco-Íris!");
        }
        
        if (image_index >= image_number - 1) {
            attack_count++;
            if (attack_count >= 3) {
                state = "kneel_down";
                sprite_index = spr_knight_kneel_down;
                image_index = 0;
            } else {
                state = "cooldown";
                sprite_index = spr_knight_still;
                alarm[0] = attack_cooldown;
            }
        }
        break;

    case "attack_slash":
        // ---> LÓGICA MATEMÁTICA DO SLASH <---
        if (image_index >= image_number * 0.4) && (!attack_hit) {
            attack_hit = true; 
            
            if (snd_miss != -1) {
                var _snd = audio_play_sound(snd_miss, 1, false);
                audio_sound_pitch(_snd, snd_pitch); 
            }
            
            // Matemática da área de acerto gigante (O desenho visual está lá no Evento Draw!)
            var _alcance_frente = 60; 
            var _raio_corte = 80;     
            var _hitbox_x = x + lengthdir_x(_alcance_frente, (image_xscale > 0 ? 0 : 180));
            var _hitbox_y = y;

            // Checa se pegou o jogador!
            if (collision_circle(_hitbox_x, _hitbox_y, _raio_corte, obj_player, false, true)) {
                global.player_hp -= damage;
                show_debug_message("Slash Gigante acertou! Dano: " + string(damage));
                
                if (snd_hit != -1) audio_play_sound(snd_hit, 1, false);
            }
        }

        if (image_index >= image_number - 1) {
            attack_count++;
            if (attack_count >= 3) {
                state = "kneel_down";
                sprite_index = spr_knight_kneel_down;
                image_index = 0;
            } else {
                state = "cooldown";
                sprite_index = spr_knight_still;
                alarm[0] = attack_cooldown;
            }
        }
        break;

    case "cooldown":
        sprite_index = spr_knight_still;
        break;

    case "kneel_down":
        if (image_index >= image_number - 1) {
            state = "kneel_still";
            sprite_index = spr_knight_kneel_still;
            image_index = 0;
            kneel_loops = 0; 
        }
        break;
        
    case "kneel_still":
        // --- LÓGICA DO ATAQUE ARCO-ÍRIS ---
        kneel_attack_timer++;
        
        // Primeiro golpe avisa (60 frames), os outros metralham (45 frames)
        var _tempo_necessario = (kneel_attack_index == 0) ? 60 : 45;
        
        if (kneel_attack_timer >= _tempo_necessario && kneel_attack_index < 7) {
            kneel_attack_timer = 0;
            
            var _inst = instance_create_layer(obj_player.x, obj_player.y, "Instances", obj_projectile_knight_blast);
            _inst.damage = damage;
            
            kneel_attack_index++;
            show_debug_message("Explosão " + string(kneel_attack_index) + "/7 lançada!");
        }

        // Lógica de animação
        if (image_index + image_speed >= image_number) {
            kneel_loops++;
            
            // Só levanta depois de disparar os 7 raios
            if (kneel_attack_index >= 7) {
                state = "kneel_stand";
                sprite_index = spr_knight_kneel_stand;
                image_index = 0;
                
                // Reseta variáveis para a próxima vez
                kneel_attack_index = 0;
                kneel_attack_timer = 0;
                kneel_loops = 0;
            }
        }
        break;
        
    case "kneel_stand":
        if (image_index >= image_number - 1) {
            attack_count = 0; 
            chase_timer = 0; 
            state = "chase"; 
        }
        break;

    // ------------------------------------------
    // TRANSIÇÃO PARA FASE 2
    // ------------------------------------------
    case "transform":
        if (image_index >= image_number - 1) {
            state = "chase2";
            move_spd *= 3;               
            attack_cooldown *= 2;       
            attack_dist = 30;
            phase2_timer = attack_cooldown; 
        }
        break;

    // ------------------------------------------
    // FASE 2: PERSEGUIÇÃO IMPLACÁVEL
    // ------------------------------------------
    case "chase2":
        sprite_index = spr_knight_walk2;
        phase2_timer--; 
        chase_timer++;  
        
        var _dist_player = point_distance(x, _meu_chao, obj_player.x, _player_chao);
        
        if (abs(obj_player.x - x) > 1) {
            image_xscale = sign(obj_player.x - x) * base_scale;
        }
        
        if (chase_timer > (attack_cooldown * 3)) {
            state = "attack_phase2"; 
            vomit_spawned = false;
            if (phase2_next_attack == "vomit") {
                sprite_index = spr_knight_vomit;
                phase2_next_attack = "buff"; 
            } else {
                sprite_index = spr_knight_buff;
                phase2_next_attack = "vomit"; 
            }
            
            image_index = 0;
            phase2_timer = attack_cooldown; 
            chase_timer = 0; 
        }
        else if (_dist_player <= attack_dist) {
            state = "attack_bite";
            sprite_index = spr_knight_bite;
            image_index = 0;
            attack_hit = false; 
        } 
        else if (phase2_timer <= 0) {
            state = "attack_phase2"; 
            vomit_spawned = false;
            if (phase2_next_attack == "vomit") {
                sprite_index = spr_knight_vomit;
                phase2_next_attack = "buff"; 
            } else {
                sprite_index = spr_knight_buff;
                phase2_next_attack = "vomit"; 
            }
            
            image_index = 0;
            phase2_timer = attack_cooldown; 
            chase_timer = 0; 
        } 
        else {
            var _dir = point_direction(x, _meu_chao, obj_player.x, _player_chao);
            var _hspd = lengthdir_x(move_spd, _dir);
            var _vspd = lengthdir_y(move_spd, _dir);
            
            if (place_meeting(x + _hspd + (sign(_hspd) * _folga), y, obj_barrier)) {
                while (!place_meeting(x + sign(_hspd), y, obj_barrier)) { x += sign(_hspd); }
                _hspd = 0;
            }
            x += _hspd;
        
            if (place_meeting(x, y + _vspd + (sign(_vspd) * _folga), obj_barrier)) {
                while (!place_meeting(x, y + sign(_vspd), obj_barrier)) { y += sign(_vspd); }
                _vspd = 0;
            }
            y += _vspd;
        }
        break;

    // ------------------------------------------
    // FASE 2: ATAQUE CORPO A CORPO (MORDIDA)
    // ------------------------------------------
    case "attack_bite":
        chase_timer++; 
        
        if (image_index >= image_number * 0.35) && (!attack_hit) {
            attack_hit = true; 
            
            var _dist_impacto = point_distance(x, _meu_chao, obj_player.x, _player_chao);
            
            if (_dist_impacto <= attack_dist + 10) { 
                global.player_hp -= damage; 
                show_debug_message("Mordida acertou! Dano: " + string(damage));
                
                if (snd_hit != -1) audio_play_sound(snd_hit, 1, false);
            } else {
                if (snd_miss != -1) {
                    var _miss_snd = audio_play_sound(snd_miss, 1, false);
                    audio_sound_pitch(_miss_snd, snd_pitch); 
                }
            }
        }
        
        if (image_index >= image_number - 1) {
            state = "chase2";
            
            if (phase2_timer < 15) {
                phase2_timer = 15; 
            }
        }
        break;

    // ------------------------------------------
    // FASE 2: ATAQUES ESPECIAIS (VÔMITO / BUFF)
    // ------------------------------------------
    case "attack_phase2":
        
        if (sprite_index == spr_knight_vomit) {
            if (image_index >= image_number * 0.9) && (!vomit_spawned) {
                vomit_spawned = true; 
                
                var _spawn_x = (image_xscale > 0) ? bbox_right : bbox_left;
                var _y_offset = 25; 
                var _spawn_y = bbox_bottom - _y_offset; 
                
                var _sahur = instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_enemy_sahur);
                _sahur.image_xscale = sign(image_xscale) * _sahur.base_scale;
                
                show_debug_message("Sahur invocado!");
            }
        }
        else if (sprite_index == spr_knight_buff) {
            if (image_index >= image_number * 0.5) && (!vomit_spawned) {
                vomit_spawned = true; 
                
                with (obj_enemy_parent) {
                    if (id != other.id) {
                        var _novo_hp = max(50, hp * 1.25);
                        hp = _novo_hp;
                        max_hp = _novo_hp;
                        
                        move_spd *= 1.2;       
                        detect_radius *= 1.10;  
                        shoot_cooldown *= 0.90; 
                        
                        damage = ceil(damage * 1.25);         
                    }
                }
                
                show_debug_message("Buff em área aplicado! Dano arredondado.");
            }
        }
        
        if (image_index >= image_number - 1) {
            state = "chase2";
        }
        break;
}