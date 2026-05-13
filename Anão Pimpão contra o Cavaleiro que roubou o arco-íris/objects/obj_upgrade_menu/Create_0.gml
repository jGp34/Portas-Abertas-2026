ini_open("meu_save.ini");
// Toca a música do menu em loop (o 'true' faz ela repetir infinitamente)
if (!audio_is_playing(msc_menu)) {
    audio_play_sound(msc_menu, 1, true);
}
// ==========================================
// 1. CUSTOS DOS UPGRADES DO JOGADOR
// ==========================================
custo_vida       = ini_read_real("Custos", "custo_vida", 5);  
custo_dano       = ini_read_real("Custos", "custo_dano", 3);  
custo_vel        = ini_read_real("Custos", "custo_vel", 4);    
custo_yield      = ini_read_real("Custos", "custo_yield", 2); 
custo_atk_speed  = ini_read_real("Custos", "custo_atk_speed", 5);  
custo_move_speed = ini_read_real("Custos", "custo_move_speed", 5); 
custo_atk_area   = ini_read_real("Custos", "custo_atk_area", 4);    
custo_critico    = ini_read_real("Custos", "custo_critico", 10);

global.crit_dano = ini_read_real("Upgrades", "crit_dano", 2);      
custo_crit_dano  = ini_read_real("Custos", "custo_crit_dano", 25); 

// ==========================================
// 2. CUSTOS DA FADA ATIRADORA
// ==========================================
custo_fada_unlock = ini_read_real("Custos", "custo_fada_unlock", 40); 
custo_fada_dano   = ini_read_real("Custos", "custo_fada_dano", 25);   
custo_fada_vel    = ini_read_real("Custos", "custo_fada_vel", 30);    
custo_fada_range  = ini_read_real("Custos", "custo_fada_range", 20);  

// ==========================================
// 3. CUSTOS DO HAMBÚRGUER CURANDEIRO
// ==========================================
custo_burguer_unlock = ini_read_real("Custos", "custo_burguer_unlock", 50); 
custo_burguer_heal   = ini_read_real("Custos", "custo_burguer_heal", 30);   
custo_burguer_speed  = ini_read_real("Custos", "custo_burguer_speed", 25);  

// ==========================================
// 4. VARIÁVEIS DE CONTROLE DO MENU
// ==========================================
menu_page = 0; 
tempo_menu = 0; // Usado para fazer as luzes da interface pulsarem

// ---> VARIÁVEIS DE ANIMAÇÃO DA DEUSA <---
goddess_sprite = spr_goddess_still;
goddess_frame = 0;
goddess_spd = sprite_get_speed(spr_goddess_still) / game_get_speed(gamespeed_fps);

ini_close();


// ==========================================
// 5. FUNÇÃO DE SALVAMENTO AUTOMÁTICO
// ==========================================
salvar_jogo = function() {
    ini_open("meu_save.ini");
    
    // Upgrades Globais
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
    
    // Custos Locais
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

    // Recursos
    ini_write_real("Recursos", "wood", global.wood);
    ini_write_real("Recursos", "iron", global.iron);
    ini_write_real("Recursos", "carvao", global.carvao);
    ini_write_real("Recursos", "gold", global.gold);
    ini_write_real("Recursos", "souls", global.souls); 
	
	ini_write_real("Progresso", "boss_morto", global.boss_morto);
    
    ini_close();
    show_debug_message("Jogo salvo com sucesso no menu!");
}