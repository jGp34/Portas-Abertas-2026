// --- obj_outro_manager -> Create ---

// ISSO É VITAL: Puxa todas as configurações do Pai
event_inherited(); 

// Define para onde vai ao terminar os créditos
target_room = rm_upgrades; 

music_asset = msc_outro;
call_later(2, time_source_units_frames, function() {
    if (!audio_is_playing(music_asset)) {
        music_id = audio_play_sound(music_asset, 1, false);
    }
});

// ---> ATIVANDO OS CRÉDITOS <---
show_credits = true;
credits_text = "Anão Pimpão contra o Cavaleiro que roubou o arco-íris\n\n\n" +
               "DESENVOLVEDORES\nAugusto\nJoão Gabriel\n\n\n" +
               "MÚSICA\nEmma Beatriz\n\n\n" +
               "FERRAMENTAS UTILIZADAS\nGameMaker: Game Engine\nPixelEngine: Animação de Pixel Art\nGemini: Ajuda no Código e Imagens\nGithub: Controle de Versão\nBandlab: Músicas\nVegas Pro 22: Edição de Áudio\n\n\n" +
               "AGRADECIMENTOS ESPECIAIS\nJorge\nVini\n\n\n" +
			   "Obrigado por jogar!";

// Define a "playlist" desta cutscene
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