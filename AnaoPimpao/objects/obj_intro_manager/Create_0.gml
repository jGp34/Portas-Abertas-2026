// --- obj_intro_manager -> Create ---
event_inherited(); 

target_room = rm_game; 
show_credits = false; // Garante que a Intro vai pular direto pro jogo!

music_asset = msc_intro;
call_later(2, time_source_units_frames, function() {
    if (!audio_is_playing(music_asset)) {
        music_id = audio_play_sound(music_asset, 1, false);
    }
});

scenes = [
    { spr: spr_intro_1,  dur: 120 },
    { spr: spr_intro_2,  dur: 120 },
    { spr: spr_intro_3,  dur: 120 },
    { spr: spr_intro_4,  dur: 120 },
    { spr: spr_intro_5,  dur: 120 },
    { spr: spr_intro_6,  dur: 120 },
    { spr: spr_intro_7,  dur: 120 },
    { spr: spr_intro_8,  dur: 120 },
    { spr: spr_intro_9,  dur: 120 },
    { spr: spr_intro_10, dur: 120 },
    { spr: spr_intro_11, dur: 120 },
    { spr: spr_intro_12, dur: 120 },
    { spr: spr_intro_13, dur: 120 },
    { spr: spr_intro_14, dur: 120 },
    { spr: spr_intro_15, dur: 120 }
];