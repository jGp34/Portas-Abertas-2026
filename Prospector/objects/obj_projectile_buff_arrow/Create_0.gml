image_xscale = 0.5; // Reduz para 50% da largura original (ajuste como quiser)
image_yscale = 0.5; // Reduz para 50% da altura original

// Define uma velocidade de subida
vspeed = random_range(-1.5, -2.5); // Sobe com velocidades variadas

// Define um tempo de vida variável
life_time = irandom_range(20, 40); // Vive entre 0.5 e 0.8 segundos
timer = 0;

// Garante que desenha na frente
depth = -bbox_bottom - 100;