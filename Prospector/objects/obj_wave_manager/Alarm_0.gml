// 1. Descobre qual onda usar (se passar do limite, trava no último índice do array)
var _ultimo_indice_possivel = array_length(ondas) - 1;
var _indice_onda = min(onda_atual, _ultimo_indice_possivel);

// Pega a lista de inimigos da onda certa
var _inimigos_da_onda = ondas[_indice_onda];
var _qtd_inimigos = array_length(_inimigos_da_onda);

// Quantos pontos de spawn existem no mapa?
var _qtd_spawners = instance_number(obj_spawner_point);

// 2. Tenta spawnar (se existir pelo menos 1 spawner no mapa)
if (_qtd_spawners > 0) {
    
    // Passa por cada inimigo que deve nascer nesta onda
    for (var i = 0; i < _qtd_inimigos; i++) {
        var _inimigo_tipo = _inimigos_da_onda[i];
        
        // Sorteia UM dos spawners espalhados pelo mapa
        var _index_sorteado = irandom(_qtd_spawners - 1);
        var _spawner_escolhido = instance_find(obj_spawner_point, _index_sorteado);
        
        // Cria o inimigo exatamente na posição (x, y) do spawner sorteado
        instance_create_layer(_spawner_escolhido.x, _spawner_escolhido.y, "Instances", _inimigo_tipo);
    }
    
    // Mostra no console se é uma onda normal ou a onda final repetida
    if (onda_atual <= _ultimo_indice_possivel) {
        show_debug_message("Onda " + string(onda_atual + 1) + " despachada!");
    } else {
        show_debug_message("Onda Infinita " + string(onda_atual + 1) + " despachada!");
    }
    
} else {
    show_debug_message("ERRO: Espalhe alguns 'obj_spawner_point' pelo mapa!");
}

// 3. O RELÓGIO: Prepara o terreno para a próxima onda
onda_atual++; // A onda atual continua subindo infinitamente (Onda 4, 5, 10, 100...)
alarm[0] = tempo_entre_ondas; // Relógio de 30 segundos