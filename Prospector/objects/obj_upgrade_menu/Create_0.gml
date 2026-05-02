// Abre o arquivo de save
ini_open("meu_save.ini");

// Lê os custos do save. Se for a primeira vez jogando, ele vai usar o número que está no final!
custo_vida = ini_read_real("Custos", "custo_vida", 5);  
custo_dano = ini_read_real("Custos", "custo_dano", 3);  
custo_vel = ini_read_real("Custos", "custo_vel", 4);    
custo_yield = ini_read_real("Custos", "custo_yield", 2); 

// ---> NOVOS CUSTOS <---
custo_atk_speed = ini_read_real("Custos", "custo_atk_speed", 5);  // Custará Ouro
custo_move_speed = ini_read_real("Custos", "custo_move_speed", 5); // Custará Carvão
custo_atk_area = ini_read_real("Custos", "custo_atk_area", 4);    // Custará Ferro

ini_close();