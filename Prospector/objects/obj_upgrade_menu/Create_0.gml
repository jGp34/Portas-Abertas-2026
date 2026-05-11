ini_open("meu_save.ini");

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
custo_fada_unlock = ini_read_real("Custos", "custo_fada_unlock", 50); 
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