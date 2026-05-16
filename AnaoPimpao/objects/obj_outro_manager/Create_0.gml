// --- obj_outro_manager -> Create ---
event_inherited(); 

target_room = rm_upgrades; 
show_credits = true;

music_asset = msc_outro;
call_later(2, time_source_units_frames, function() {
    if (!audio_is_playing(music_asset)) {
        music_id = audio_play_sound(music_asset, 1, false);
    }
});

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
    { tipo: "nome",             texto: "Arthur: Teste\nJorge: Organização\nVini: Imagem" },
    { tipo: "espaco",           texto: "" },
    { tipo: "espaco",           texto: "" },
    { tipo: "agradecimento",    texto: "Obrigado por jogar!" }
];

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
    { spr: spr_outro_13, dur: 120 }
];