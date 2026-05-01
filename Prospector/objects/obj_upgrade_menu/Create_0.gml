// Abre o arquivo de save
ini_open("meu_save.ini");

// Lê os custos do save. Se for a primeira vez jogando, ele vai usar o número que está no final!
custo_vida = ini_read_real("Custos", "custo_vida", 5);  // Base: 5 (Madeira)
custo_dano = ini_read_real("Custos", "custo_dano", 3);  // Base: 3 (Ferro)
custo_vel = ini_read_real("Custos", "custo_vel", 4);    // Base: 4 (Carvão)
custo_yield = ini_read_real("Custos", "custo_yield", 2); // Base: 2 (Ouro)

ini_close();