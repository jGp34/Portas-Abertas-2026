// 1. Descobre qual onda usar baseado no progresso e no modo infinito
var _ultimo_indice_possivel = array_length(ondas) - 1; // Índice 9
var _indice_onda = onda_atual;
var _duplicar = false;

// Se passou do limite estruturado (Onda 10 / Índice 9 em diante)
if (_indice_onda > _ultimo_indice_possivel) {
    // Sequência de 10 em 10 ondas após o primeiro boss (18, 28, 38...)
    if (global.boss_morto && (_indice_onda % 10 == 8)) {
        _indice_onda = 8; // Força a onda do Cavaleiro (Boss)
    } else {
        _indice_onda = 9; // Repete a horda da onda 9
    }
}

// ---> NOVA REGRA: DUPLICAÇÃO A PARTIR DA ONDA[20] A CADA 5 ONDAS <---
if (global.boss_morto && onda_atual >= 20 && (onda_atual % 5 == 0)) {
    _duplicar = true;
}

// Pega a lista de inimigos da onda definida
var _inimigos_da_onda = ondas[_indice_onda];
var _qtd_inimigos = array_length(_inimigos_da_onda);

// Quantos pontos de spawn existem no mapa?
var _qtd_spawners = instance_number(obj_spawner_point);

// 2. Tenta spawnar (se existir pelo menos 1 spawner no mapa)
if (_qtd_spawners > 0) {
    
    // MÁGICA DA DUPLICAÇÃO: Se _duplicar for true, roda o bloco de spawn 2 vezes!
    var _repeticoes_spawn = _duplicar ? 2 : 1;
    
    repeat (_repeticoes_spawn) {
        // Passa por cada inimigo que deve nascer nesta onda
        for (var i = 0; i < _qtd_inimigos; i++) {
            var _inimigo_tipo = _inimigos_da_onda[i];
            
            // Sorteia UM dos spawners espalhados pelo mapa
            var _index_sorteado = irandom(_qtd_spawners - 1);
            var _spawner_escolhido = instance_find(obj_spawner_point, _index_sorteado);
            
            // Cria o inimigo
            var _novo_inimigo = instance_create_layer(_spawner_escolhido.x, _spawner_escolhido.y, "Instances", _inimigo_tipo);
            
            // =======================================================
            // SISTEMA ANTI-STUCK (Desempacar da parede)
            // =======================================================
            with (_novo_inimigo) {
                var _dir_centro = point_direction(x, y, room_width / 2, room_height / 2);
                var _limite = 500; 
                
                while (place_meeting(x, y, obj_barrier) && _limite > 0) {
                    x += lengthdir_x(1, _dir_centro);
                    y += lengthdir_y(1, _dir_centro);
                    _limite--;
                }
                
                spawn_x = x;
                spawn_y = y;
            }
            // =======================================================
        }
    }
    
    // Mostra no console o status exato do spawn para ajudar nos testes
    if (onda_atual <= _ultimo_indice_possivel) {
        show_debug_message("Onda " + string(onda_atual + 1) + " despachada!");
    } else {
        var _msg = "Onda Infinita " + string(onda_atual + 1);
        if (_indice_onda == 8) _msg += " [O RETORNO DO CAVALEIRO]";
        else _msg += " [Horda Replicada]";
        
        if (_duplicar) _msg += " [CONTEÚDO DUPLICADO 2X!]";
        show_debug_message(_msg + " despachada!");
    }
    
} else {
    show_debug_message("ERRO: Espalhe alguns 'obj_spawner_point' pelo mapa!");
}

// 3. O RELÓGIO: Prepara o terreno para a próxima onda
onda_atual++; 
alarm[0] = tempo_entre_ondas;