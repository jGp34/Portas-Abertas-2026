// --- obj_genie -> Create ---
state = "hidden"; // Estados: "hidden", "active", "reward", "timeout"

var _fps = game_get_speed(gamespeed_fps);

// Aos 45s (base) + de 0 a 60s (próximo minuto)
spawn_timer = (45 + irandom(45)) * _fps; 
active_timer = 0;

image_xscale = 0.3;
image_yscale = 0.3;

// Esconde o gênio no começo
visible = false;
x = -1000;
y = -1000;