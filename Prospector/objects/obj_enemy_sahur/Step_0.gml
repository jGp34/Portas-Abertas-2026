if (!instance_exists(obj_player)) exit;

// 1. GARANTIR QUE ELE POSSA MORRER ENQUANTO NASCE (Se o jogador bater nele)
if (hp <= 0) {
    event_inherited(); // Chama a lógica de morte do pai e drop de souls
    exit;
}

// 2. LÓGICA DO NASCIMENTO (Trava a IA até acabar)
if (state == "birth") {
    
    // Fica parado enquanto a animação de nascer roda
    if (image_index >= image_number - 1) {
        state = "idle"; // Terminou de nascer! Agora a IA do pai assume.
    } else {
        exit; // Impede que o código continue e rode a perseguição do pai
    }
}

// 3. EXECUTA A INTELIGÊNCIA ARTIFICIAL PADRÃO
// Como setamos o detect_radius para 9999, o pai vai fazer ele caçar o player pra sempre
event_inherited();