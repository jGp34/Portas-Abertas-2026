// Se foi coletado, começa a desaparecer
if (coletado) {
    image_alpha -= fade_speed; // Perde transparência
    
    // Sumiu completamente? Destrói.
    if (image_alpha <= 0) {
        instance_destroy();
    }
}