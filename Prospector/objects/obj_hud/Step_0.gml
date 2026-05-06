// =======================================================
// TELA CHEIA (FULLSCREEN)
// =======================================================
if (keyboard_check_pressed(vk_f11)) {
    // Se já estiver em tela cheia, volta para a janela. Se não, tela cheia!
    if (window_get_fullscreen()) {
        window_set_fullscreen(false);
    } else {
        window_set_fullscreen(true);
    }
}