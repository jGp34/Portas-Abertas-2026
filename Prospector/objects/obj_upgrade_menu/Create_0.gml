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
custo_critico = ini_read_real("Custos", "custo_critico", 10);

custo_fada_unlock = ini_read_real("Custos", "custo_fada_unlock", 50); // Custa Souls para liberar
custo_fada_dano = ini_read_real("Custos", "custo_fada_dano", 25);     // Custa Ouro para upar dano
custo_fada_vel = ini_read_real("Custos", "custo_fada_vel", 30);       // Custa Ouro para atirar mais rápido
custo_fada_range = ini_read_real("Custos", "custo_fada_range", 20);   // Custa Ferro (Exemplo)

// ---> CUSTOS DO HAMBÚRGUER <---
custo_burguer_unlock = ini_read_real("Custos", "custo_burguer_unlock", 50); // Custa Souls para liberar
custo_burguer_heal = ini_read_real("Custos", "custo_burguer_heal", 30);     // Custa Ouro para upar a quantidade curada
custo_burguer_speed = ini_read_real("Custos", "custo_burguer_speed", 25);   // Custa Ferro para curar mais rápido

menu_page = 0;
ini_close();