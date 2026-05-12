timer++;

// Começa a sumir (fade out) na metade da vida
if (timer > life_time / 2) {
    image_alpha -= 0.05; 
}

// Destrói quando o tempo de vida acabar ou ficar invisível
if (timer >= life_time || image_alpha <= 0) {
    instance_destroy();
}