// Crie como um objeto limpo (sem event_inherited())
hp = 1; 
damage = 20; // Default, mas será sobrescrito pelo Golem
move_spd = 4.5; // Velocidade maior que a do esqueleto (que era 2.5)

// --- AJUSTE DE TAMANHO ---
image_xscale = 1.15; 
image_yscale = 1.15;

// OBS: A direction e o image_angle serão definidos pelo próprio obj_enemy_golem
// no momento exato em que ele cria este projétil.