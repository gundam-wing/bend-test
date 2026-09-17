import Game from "./game.bend";

const canvas = document.getElementById("screen");
const ctx = canvas.getContext("2d");
ctx.imageSmoothingEnabled = false;
const pixels = ctx.createImageData(256, 256);

let game = Game.start();
const held = new Set();

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

function pair(v) {
  if (!v) return [v, v];
  if (v.$ === "Tuple") return [v.fst, v.snd];
  if (Array.isArray(v)) return v;
  if ("fst" in v && "snd" in v) return [v.fst, v.snd];
  return [v, v];
}

function draw() {
  const [next, image] = pair(Game.look(game));
  game = next;
  blit(image, 0, 0, 256);
  ctx.putImageData(pixels, 0, 0);
}

function codeOf(ev) {
  if (ev.key === "Escape") return 27;
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

function tick() {
  const next = Game.step({ $: "Nil" }, game);
  if (next && next.$ === "Some") game = next.value;
  draw();
  requestAnimationFrame(tick);
}

draw();
requestAnimationFrame(tick);
