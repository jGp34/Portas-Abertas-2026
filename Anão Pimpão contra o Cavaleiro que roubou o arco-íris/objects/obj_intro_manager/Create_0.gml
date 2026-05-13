// --- obj_intro_manager -> Create ---

// ISSO É VITAL: Puxa todas as configurações do Pai (resolução, fade, etc)
event_inherited(); 

// Define para onde essa cutscene específica vai ao terminar
target_room = rm_game; 
call_later(2, time_source_units_frames, function() {
    if (!audio_is_playing(msc_intro)) {
        audio_play_sound(msc_intro, 1, false);
    }
});
// Define a "playlist" desta cutscene
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