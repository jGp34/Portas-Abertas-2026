// Inherit obj_collision logic (if it has any)
event_inherited(); 

// Variáveis base (serão sobrescritas nos filhos)
tempo_mineracao_max = 120;  
timer_atual = 0;
distancia_minima = 40; 
tipo_minerio = "carvao"; // Define qual minério esse objeto dá