timer -= 1;

if (timer <= 0) {
    // Verifica quantas minas existem no mapa
    var _total_minas = instance_number(obj_mine_ore);
    
    // Precisamos de pelo menos 2 minas para existir uma origem e um destino
    if (_total_minas >= 2) {
        
        // 1. Sorteia a mina de ORIGEM
        var _idx_start = irandom(_total_minas - 1);
        var _mina_start = instance_find(obj_mine_ore, _idx_start);
        
        // 2. Sorteia a mina de DESTINO
        var _idx_end = irandom(_total_minas - 1);
        var _mina_end = instance_find(obj_mine_ore, _idx_end);
        
        // Garante que a origem e o destino não sejam a mesma pedra
        while (_mina_end.id == _mina_start.id) {
            _idx_end = irandom(_total_minas - 1);
            _mina_end = instance_find(obj_mine_ore, _idx_end);
        }
        
        // Agora sim podemos somar com segurança!
        global.kobolds_spawned += 1;
        
        // 3. Cria UM ÚNICO Kobold na mina de origem
        var _kobold = instance_create_layer(_mina_start.x, _mina_start.y, "Instances", obj_enemy_kobold);
        
        // 4. Passa as informações de destino e qual número ele é
        _kobold.destino_x = _mina_end.x;
        _kobold.destino_y = _mina_end.y;
        _kobold.meu_numero_spawn = global.kobolds_spawned;
        
        show_debug_message("Kobold #" + string(global.kobolds_spawned) + " nasceu!");
    }
    
    // Reseta o cronômetro para os próximos 30 segundos
    timer = spawn_interval;
}