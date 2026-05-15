// =======================================================
// TELA CHEIA (FULLSCREEN)
// =======================================================
if (keyboard_check_pressed(vk_f11)) {
    var _is_fullscreen = window_get_fullscreen();
    window_set_fullscreen(!_is_fullscreen);

    call_later(1, time_source_units_frames, function() {
        if (window_get_fullscreen()) {
            surface_resize(application_surface, display_get_width(), display_get_height());
        } else {
            surface_resize(application_surface, window_get_width(), window_get_height());
        }
    });
}

// =======================================================
// LÓGICA DA HUD (Animação suave da Barra de Vida)
// =======================================================
// Se a variável de animação não existir, o GameMaker cria ela agora
if (!variable_instance_exists(id, "hp_smooth")) {
    hp_smooth = global.player_hp;
}

// O lerp faz a barra "hp_smooth" perseguir a vida real devagarinho (10% a cada frame)
hp_smooth = lerp(hp_smooth, global.player_hp, 0.1);



