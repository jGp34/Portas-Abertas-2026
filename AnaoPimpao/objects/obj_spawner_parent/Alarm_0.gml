// 1. Conta apenas os goblins criados POR ESTE spawner
var _meus_vivos = 0;

with (inimigo_para_spawnar) {
    if (meu_spawner == other.id) {
        _meus_vivos++; // Se a etiqueta for igual a este spawner, soma 1
    }
}

// 2. Tenta spawnar
if (_meus_vivos < limite_maximo) {
    // Cria o inimigo e guarda a ID dele numa variável temporária
    var _novo_inimigo = instance_create_layer(x, y, "Instances", inimigo_para_spawnar);
    
    // Etiqueta o inimigo com a ID deste spawner!
    _novo_inimigo.meu_spawner = id; 
    
    show_debug_message("Spawnado pelo Spawner " + string(id) + " | Meus Vivos: " + string(_meus_vivos + 1));
}

// 3. O RELÓGIO: Reinicia o alarme para a próxima tentativa
alarm[0] = tempo_spawn;