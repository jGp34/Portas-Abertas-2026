const CONFIG = {
  map: { width: 2400, height: 1600 },
  player: {
    baseMaxHealth: 15,
    baseDamage: 2,
    baseSpeed: 2.4,
    radius: 16,
    attackRange: 150,
    attackCooldown: 0.45,
  },
  enemy: {
    radius: 13,
    baseHealth: 4,
    baseSpeed: 1.2,
    baseDamage: 1,
    contactCooldown: 0.7,
  },
  progression: {
    spawnStartInterval: 2.0,
    spawnMinInterval: 0.35,
    spawnAccelerationPerSecond: 0.015,
    scalingPerSecond: 0.025,
    goldPerEnemy: 3,
    upgradeCost: 10,
  },
};

const canvas = document.getElementById('game-canvas');
const ctx = canvas.getContext('2d');

const ui = {
  hp: document.getElementById('hp-value'),
  damage: document.getElementById('damage-value'),
  gold: document.getElementById('gold-value'),
  time: document.getElementById('time-value'),
  menu: document.getElementById('upgrade-menu'),
  buttons: {
    health: document.getElementById('upgrade-health'),
    damage: document.getElementById('upgrade-damage'),
    speed: document.getElementById('upgrade-speed'),
    restart: document.getElementById('restart-run'),
  },
};

const permanentUpgrades = {
  maxHealth: 0,
  damage: 0,
  speed: 0,
};

const state = {
  running: true,
  time: 0,
  gold: 0,
  player: null,
  enemies: [],
  input: { up: false, down: false, left: false, right: false },
  spawnTimer: 0,
};

const resetRun = () => {
  state.running = true;
  state.time = 0;
  state.enemies = [];
  state.spawnTimer = 0;

  state.player = {
    x: CONFIG.map.width / 2,
    y: CONFIG.map.height / 2,
    radius: CONFIG.player.radius,
    maxHealth: CONFIG.player.baseMaxHealth + permanentUpgrades.maxHealth,
    health: CONFIG.player.baseMaxHealth + permanentUpgrades.maxHealth,
    damage: CONFIG.player.baseDamage + permanentUpgrades.damage,
    speed: CONFIG.player.baseSpeed + permanentUpgrades.speed,
    attackTimer: 0,
    contactTimers: new Map(),
  };

  ui.menu.classList.add('hidden');
  syncUpgradeButtons();
};

const spawnEnemy = () => {
  const edge = Math.floor(Math.random() * 4);
  const padding = 40;
  let x = 0;
  let y = 0;

  if (edge === 0) {
    x = Math.random() * CONFIG.map.width;
    y = -padding;
  } else if (edge === 1) {
    x = CONFIG.map.width + padding;
    y = Math.random() * CONFIG.map.height;
  } else if (edge === 2) {
    x = Math.random() * CONFIG.map.width;
    y = CONFIG.map.height + padding;
  } else {
    x = -padding;
    y = Math.random() * CONFIG.map.height;
  }

  const scale = 1 + state.time * CONFIG.progression.scalingPerSecond;
  state.enemies.push({
    id: crypto.randomUUID(),
    x,
    y,
    radius: CONFIG.enemy.radius,
    health: Math.max(1, Math.round(CONFIG.enemy.baseHealth * scale)),
    speed: CONFIG.enemy.baseSpeed * Math.min(2, scale),
    damage: Math.max(1, Math.round(CONFIG.enemy.baseDamage * scale)),
  });
};

const updatePlayer = (dt) => {
  const p = state.player;
  let dx = 0;
  let dy = 0;

  if (state.input.up) dy -= 1;
  if (state.input.down) dy += 1;
  if (state.input.left) dx -= 1;
  if (state.input.right) dx += 1;

  if (dx || dy) {
    const len = Math.hypot(dx, dy);
    p.x += (dx / len) * p.speed * 120 * dt;
    p.y += (dy / len) * p.speed * 120 * dt;
  }

  p.x = Math.max(0, Math.min(CONFIG.map.width, p.x));
  p.y = Math.max(0, Math.min(CONFIG.map.height, p.y));

  p.attackTimer -= dt;
  if (p.attackTimer <= 0) {
    const target = state.enemies
      .filter((enemy) => distance(p, enemy) <= CONFIG.player.attackRange)
      .sort((a, b) => distance(p, a) - distance(p, b))[0];

    if (target) {
      target.health -= p.damage;
      p.attackTimer = CONFIG.player.attackCooldown;
    }
  }
};

const updateEnemies = (dt) => {
  const p = state.player;

  for (const enemy of state.enemies) {
    const dx = p.x - enemy.x;
    const dy = p.y - enemy.y;
    const len = Math.hypot(dx, dy) || 1;
    enemy.x += (dx / len) * enemy.speed * 90 * dt;
    enemy.y += (dy / len) * enemy.speed * 90 * dt;

    const touching = distance(enemy, p) <= enemy.radius + p.radius;
    if (touching) {
      const cooldownRemaining = p.contactTimers.get(enemy.id) || 0;
      if (cooldownRemaining <= 0) {
        p.health -= enemy.damage;
        p.contactTimers.set(enemy.id, CONFIG.enemy.contactCooldown);
      }
    }
  }

  for (const [enemyId, timeLeft] of p.contactTimers.entries()) {
    const next = timeLeft - dt;
    if (next <= 0) p.contactTimers.delete(enemyId);
    else p.contactTimers.set(enemyId, next);
  }

  const before = state.enemies.length;
  state.enemies = state.enemies.filter((enemy) => enemy.health > 0);
  const defeated = before - state.enemies.length;
  if (defeated > 0) {
    state.gold += defeated * CONFIG.progression.goldPerEnemy;
  }
};

const updateSpawns = (dt) => {
  state.spawnTimer -= dt;
  const interval = Math.max(
    CONFIG.progression.spawnMinInterval,
    CONFIG.progression.spawnStartInterval - state.time * CONFIG.progression.spawnAccelerationPerSecond,
  );

  if (state.spawnTimer <= 0) {
    spawnEnemy();
    state.spawnTimer = interval;
  }
};

const distance = (a, b) => Math.hypot(a.x - b.x, a.y - b.y);

const draw = () => {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  const p = state.player;
  const cameraX = Math.max(0, Math.min(CONFIG.map.width - canvas.width, p.x - canvas.width / 2));
  const cameraY = Math.max(0, Math.min(CONFIG.map.height - canvas.height, p.y - canvas.height / 2));

  drawMap(cameraX, cameraY);

  for (const enemy of state.enemies) {
    drawCircle(enemy.x - cameraX, enemy.y - cameraY, enemy.radius, '#e65050');
  }

  drawCircle(p.x - cameraX, p.y - cameraY, p.radius, '#6bc8ff');

  ctx.beginPath();
  ctx.strokeStyle = 'rgba(107,200,255,0.35)';
  ctx.lineWidth = 1;
  ctx.arc(p.x - cameraX, p.y - cameraY, CONFIG.player.attackRange, 0, Math.PI * 2);
  ctx.stroke();
};

const drawMap = (cameraX, cameraY) => {
  ctx.fillStyle = '#1b212b';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.fillStyle = '#263042';
  const grid = 80;
  for (let x = Math.floor(cameraX / grid) * grid; x <= cameraX + canvas.width; x += grid) {
    ctx.fillRect(x - cameraX, -cameraY, 1, canvas.height + 2);
  }
  for (let y = Math.floor(cameraY / grid) * grid; y <= cameraY + canvas.height; y += grid) {
    ctx.fillRect(-cameraX, y - cameraY, canvas.width + 2, 1);
  }

  ctx.strokeStyle = '#3f4d64';
  ctx.lineWidth = 3;
  ctx.strokeRect(-cameraX, -cameraY, CONFIG.map.width, CONFIG.map.height);
};

const drawCircle = (x, y, radius, color) => {
  ctx.beginPath();
  ctx.fillStyle = color;
  ctx.arc(x, y, radius, 0, Math.PI * 2);
  ctx.fill();
};

const updateHud = () => {
  const p = state.player;
  ui.hp.textContent = `${Math.max(0, Math.ceil(p.health))}/${p.maxHealth}`;
  ui.damage.textContent = `${p.damage}`;
  ui.gold.textContent = `${state.gold}`;
  ui.time.textContent = state.time.toFixed(1);
};

const syncUpgradeButtons = () => {
  const canAfford = state.gold >= CONFIG.progression.upgradeCost;
  ui.buttons.health.disabled = !canAfford;
  ui.buttons.damage.disabled = !canAfford;
  ui.buttons.speed.disabled = !canAfford;
};

const spendUpgrade = (key) => {
  if (state.gold < CONFIG.progression.upgradeCost) {
    syncUpgradeButtons();
    return;
  }

  const upgradeValueByKey = {
    maxHealth: 5,
    damage: 1,
    speed: 0.15,
  };

  state.gold -= CONFIG.progression.upgradeCost;
  permanentUpgrades[key] += upgradeValueByKey[key];
  syncUpgradeButtons();
  updateHud();
};

ui.buttons.health.addEventListener('click', () => spendUpgrade('maxHealth'));
ui.buttons.damage.addEventListener('click', () => spendUpgrade('damage'));
ui.buttons.speed.addEventListener('click', () => spendUpgrade('speed'));
ui.buttons.restart.addEventListener('click', resetRun);

window.addEventListener('keydown', (event) => {
  if (event.key === 'w' || event.key === 'ArrowUp') state.input.up = true;
  if (event.key === 's' || event.key === 'ArrowDown') state.input.down = true;
  if (event.key === 'a' || event.key === 'ArrowLeft') state.input.left = true;
  if (event.key === 'd' || event.key === 'ArrowRight') state.input.right = true;
});

window.addEventListener('keyup', (event) => {
  if (event.key === 'w' || event.key === 'ArrowUp') state.input.up = false;
  if (event.key === 's' || event.key === 'ArrowDown') state.input.down = false;
  if (event.key === 'a' || event.key === 'ArrowLeft') state.input.left = false;
  if (event.key === 'd' || event.key === 'ArrowRight') state.input.right = false;
});

let previousTs = performance.now();
const tick = (ts) => {
  const dt = Math.min(0.05, (ts - previousTs) / 1000);
  previousTs = ts;

  if (state.running) {
    state.time += dt;
    updatePlayer(dt);
    updateEnemies(dt);
    updateSpawns(dt);

    if (state.player.health <= 0) {
      state.running = false;
      ui.menu.classList.remove('hidden');
      syncUpgradeButtons();
    }
  }

  draw();
  updateHud();
  requestAnimationFrame(tick);
};

resetRun();
requestAnimationFrame(tick);
