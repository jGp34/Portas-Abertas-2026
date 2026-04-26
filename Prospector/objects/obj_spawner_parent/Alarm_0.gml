// 1. Checa a contagem
var _vivos = instance_number(inimigo_para_spawnar);

// 2. Tenta spawnar
if (_vivos < limite_maximo) {
    instance_create_layer(x, y, "Instances", inimigo_para_spawnar);
    show_debug_message("Spawnado: " + object_get_name(inimigo_para_spawnar) + " | Total: " + string(_vivos + 1));
}

// 3. O RELÓGIO: Reinicia o alarme para a próxima tentativa
alarm[0] = tempo_spawn;