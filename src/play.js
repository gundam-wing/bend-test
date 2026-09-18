import Game from "./game.bend";

const canvas = document.getElementById("screen");
const ctx = canvas.getContext("2d");
ctx.imageSmoothingEnabled = false;
const pixels = ctx.createImageData(256, 256);

const dialogueEl = document.getElementById("dialogue");
const whoEl = document.getElementById("who");
const lineEl = document.getElementById("line");
const votesEl = document.getElementById("votes");
const brainsEl = document.getElementById("brains");
const placeEl = document.getElementById("place");

let game = Game.start();
const held = new Set();

const MAPS = [
  "Lily Pad Village",
  "Reed Swamp",
  "Copper Cog Lab",
  "Mist Shrine",
  "Throne Hall"
];

const NAMES = {
  0: "Narrator",
  1: "Elder Lily",
  2: "Engineer Toad",
  3: "Captain Newt",
  4: "Merchant Tad",
  5: "Oracle Sal",
  6: "The Throne"
};

function linesFor(npc, step, allies, flags, brains) {
  const intro = (flags & 1) !== 0;
  const hasEng = (allies & 2) !== 0;
  const hasCap = (allies & 4) !== 0;
  const votesReady = /* approximate from bits */ true;

  const scripts = {
    1: intro
      ? [
          "The swamp listens, wizard. Four seats still withhold their word.",
          "Return when Engineer, Captain, Merchant, and Oracle stand with you.",
          "Then I will cast the fifth vote — and name you Frog King."
        ]
      : [
          "Ribbit the Wizard… the old crown lies cold. The land needs a king of progress.",
          "Gain consensus from five council seats. Speak, listen, and prove the future is kind.",
          "Start with Engineer Toad in the lab north of the warp pad. The age of cog and lily begins with trust."
        ],
    2: !intro
      ? [
          "No appointment, no audience. Talk to Elder Lily first.",
          "Consensus is a protocol. I do not skip handshakes.",
          "Village first. Then we discuss the Grand Diffuser."
        ]
      : brains >= 3
        ? [
            "Three fly brains! Perfect fuel for the neural loom.",
            "With this, reed villages get clean light and message-pads.",
            "You have my vote, Frog King. Build carefully — and boldly."
          ]
        : [
            "I will back a king who feeds the loom. Bring three fly brains from Reed Swamp.",
            "East warp from the village. Watch the water. Mind the trees.",
            `You hold ${brains} / 3. Return when the satchel sings.`
          ],
    3: !intro
      ? [
          "State your business. The reed paths are not a playground.",
          "Elder Lily must open the council road before I hear petitions.",
          "Move along, wizard."
        ]
      : [
          "You walk my swamp with purpose. That counts.",
          "A king of progress still needs a shield. I will be yours.",
          "Captain Newt votes aye. Keep the paths safe for every tadpole."
        ],
    4: !hasEng
      ? [
          "Trade follows certainty. Convince the Engineer first.",
          "When the loom lights, my barges will carry parts and pollen.",
          "No vote until the lab signs on."
        ]
      : [
          "Ah! The Diffuser will need copper, glass, and gossip.",
          "Promise open docks in the new age and my ledgers cheer.",
          "Merchant Tad votes for the Frog King of progress!"
        ],
    5: !(hasEng && hasCap)
      ? [
          "Mist hides the future. Bring Engineer's spark and Captain's steel.",
          "Only then will the shrine name a sovereign.",
          "Walk the maps. Earn those two seals."
        ]
      : [
          "I see rails of light across the wetlands… and soft moss still green.",
          "Technology without cruelty. That is the prophecy you carry.",
          "Oracle Sal joins the consensus. Ascend."
        ],
    6: [
      "The throne hums, waiting for five living votes.",
      "Sit only when the council is whole.",
      "Press on — or claim the crown if consensus is complete."
    ]
  };

  const list = scripts[npc] || ["…"];
  return list[Math.min(step, list.length - 1)];
}

function pair(v) {
  if (!v) return [v, v];
  if (v.$ === "Tuple") return [v.fst, v.snd];
  if (Array.isArray(v)) return v;
  if ("fst" in v && "snd" in v) return [v.fst, v.snd];
  return [v, v];
}

function peek(fn) {
  const [next, value] = pair(fn(game));
  game = next;
  return value >>> 0;
}

function rgb(color) {
  const c = color >>> 0;
  return [(c >> 16) & 255, (c >> 8) & 255, c & 255];
}

function blit(img, x, y, size) {
  if (!img) return;
  if (img.$ === "Pix") {
    const [r, g, b] = rgb(img.color);
    for (let dy = 0; dy < size; dy++) {
      for (let dx = 0; dx < size; dx++) {
        const i = ((y + dy) * 256 + (x + dx)) * 4;
        pixels.data[i] = r;
        pixels.data[i + 1] = g;
        pixels.data[i + 2] = b;
        pixels.data[i + 3] = 255;
      }
    }
    return;
  }
  const h = size / 2;
  blit(img.tl, x, y, h);
  blit(img.tr, x + h, y, h);
  blit(img.bl, x, y + h, h);
  blit(img.br, x + h, y + h, h);
}

function syncUi() {
  const mode = peek(Game.peek_mode);
  const votes = peek(Game.peek_votes);
  const brains = peek(Game.peek_brains);
  const allies = peek(Game.peek_allies);
  const flags = peek(Game.peek_flags);
  const mapId = peek(Game.peek_map);
  const npc = peek(Game.peek_talk_npc);
  const step = peek(Game.peek_talk_step);

  votesEl.textContent = `Council: ${votes} / 5`;
  brainsEl.textContent = `Brains: ${brains} / 3`;
  placeEl.textContent = MAPS[mapId] || "Unknown";

  if (mode === 0) {
    dialogueEl.classList.add("show");
    whoEl.textContent = "Frog King";
    lineEl.textContent =
      "You are Ribbit the Wizard. Press Space to begin your campaign for the crown of progress.";
  } else if (mode === 2) {
    dialogueEl.classList.add("show");
    whoEl.textContent = NAMES[npc] || "Someone";
    lineEl.textContent = linesFor(npc, step, allies, flags, brains);
  } else if (mode === 3) {
    dialogueEl.classList.add("show");
    whoEl.textContent = "Coronation";
    lineEl.textContent =
      "The five seats speak as one. Hail Frog King Ribbit — usher of the lily-tech age! Press R to play again.";
  } else {
    dialogueEl.classList.remove("show");
  }
}

function draw() {
  const [next, image] = pair(Game.look(game));
  game = next;
  blit(image, 0, 0, 256);
  ctx.putImageData(pixels, 0, 0);
  syncUi();
}

function codeOf(ev) {
  if (ev.key === "Escape") return 27;
  if (ev.key === "Enter") return 13;
  if (ev.key === " ") return 32;
  if (ev.key === "ArrowUp") return 63232;
  if (ev.key === "ArrowDown") return 63233;
  if (ev.key === "ArrowLeft") return 63234;
  if (ev.key === "ArrowRight") return 63235;
  if (ev.key.length === 1) return ev.key.toLowerCase().charCodeAt(0);
  return 0;
}

function keyEvent(ev, down) {
  const code = codeOf(ev);
  if (!code) return;
  ev.preventDefault();
  if (down) {
    if (held.has(code)) return;
    held.add(code);
  } else {
    held.delete(code);
  }
  const list = {
    $: "Con",
    head: { $: "Key", code, down },
    tail: { $: "Nil" }
  };
  const next = Game.step(list, game);
  if (!next || next.$ === "None") return;
  game = next.value;
}

window.addEventListener("keydown", (ev) => keyEvent(ev, true));
window.addEventListener("keyup", (ev) => keyEvent(ev, false));
canvas.addEventListener("click", () => canvas.focus());

function tick() {
  const next = Game.step({ $: "Nil" }, game);
  if (next && next.$ === "Some") game = next.value;
  draw();
  requestAnimationFrame(tick);
}

canvas.focus();
draw();
requestAnimationFrame(tick);
