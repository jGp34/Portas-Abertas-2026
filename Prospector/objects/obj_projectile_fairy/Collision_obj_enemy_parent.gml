// Causa o dano
other.hp -= damage;

// Mostra o feedback
show_debug_message("A Fada causou " + string(damage) + " de dano!");

// Se você tiver um som de impacto mágico, coloque aqui:
// audio_play_sound(sfx_magic_hit, 1, false);

instance_destroy(); // Destrói o projétil