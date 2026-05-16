// --- obj_outro_manager -> Create ---

// ISSO É VITAL: Puxa todas as configurações do Pai (como o obj_cutscene_manager)
event_inherited(); 

// Define para onde vai ao terminar os créditos
target_room = rm_upgrades; 

// --- CONFIGURAÇÃO DE ÁUDIO ---
music_asset = msc_outro;
call_later(2, time_source_units_frames, function() {
    if (!audio_is_playing(music_asset)) {
        music_id = audio_play_sound(music_asset, 1, false);
    }
});

// --- ATIVANDO OS CRÉDITOS ---
show_credits = true;

// Define onde o texto começa a subir (logo abaixo do limite da tela de quem estiver jogando)
credits_y = display_get_gui_height() + 50; 

// Estruturação dos Créditos em formato Premium (permite cores e fontes diferentes no Draw GUI)
credits_data = [
    { tipo: "titulo_principal", texto: "Anão Pimpão contra o Cavaleiro que roubou o arco-íris" },
    { tipo: "espaco",           texto: "" },
    { tipo: "titulo",           texto: "DESENVOLVEDORES" },
    { tipo: "nome",             texto: "Augusto\nJoão Gabriel" },
    { tipo: "espaco",           texto: "" },
    { tipo: "titulo",           texto: "MÚSICA" },
    { tipo: "nome",             texto: "Emma Beatriz" },
    { tipo: "espaco",           texto: "" },
    { tipo: "titulo",           texto: "FERRAMENTAS UTILIZADAS" },
    { tipo: "nome",             texto: "GameMaker: Game Engine\nPixelEngine: Animação de Pixel Art\nGemini: Ajuda no Código e Imagens\nGithub: Controle de Versão\nBandlab: Músicas\nVegas Pro 22: Edição de Áudio" },
    { tipo: "espaco",           texto: "" },
    { tipo: "titulo",           texto: "AGRADECIMENTOS ESPECIAIS" },
    { tipo: "nome",             texto: "Jorge\nVini" },
    { tipo: "espaco",           texto: "" },
    { tipo: "espaco",           texto: "" },
    { tipo: "agradecimento",    texto: "Obrigado por jogar!" }
];

// MÁGICA DE CÁLCULO: Mede o tamanho total que o texto vai ocupar para saber a hora exata de encerrar o jogo
draw_set_font(fnt_text); // Força o uso da sua fonte de texto para medir corretamente
credits_total_height = 0;

for (var i = 0; i < array_length(credits_data); i++) {
    var _item = credits_data[i];
    if (_item.tipo == "titulo_principal") {
        credits_total_height += string_height(_item.texto) * 1.5 + 40;
    }
    else if (_item.tipo == "titulo") {
        credits_total_height += string_height(_item.texto) * 1.2 + 20;
    }
    else if (_item.tipo == "nome") {
        credits_total_height += string_height(_item.texto) + 40;
    }
    else if (_item.tipo == "agradecimento") {
        credits_total_height += string_height(_item.texto) * 1.5 + 40;
    }
    else if (_item.tipo == "espaco") {
        credits_total_height += 40;
    }
}

// --- PLAYLIST DA CUTSCENE ANIMADA ---
scenes = [
    { spr: spr_outro_1,  dur: 120 },
    { spr: spr_outro_2,  dur: 120 },
    { spr: spr_outro_3,  dur: 120 },
    { spr: spr_outro_4,  dur: 120 },
    { spr: spr_outro_5,  dur: 120 },
    { spr: spr_outro_6,  dur: 120 },
    { spr: spr_outro_7,  dur: 120 },
    { spr: spr_outro_8,  dur: 120 },
    { spr: spr_outro_9,  dur: 120 },
    { spr: spr_outro_10, dur: 120 },
    { spr: spr_outro_11, dur: 120 },
    { spr: spr_outro_12, dur: 120 },
    { spr: spr_outro_13, dur: 120 },
];