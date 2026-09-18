#!/usr/bin/env bun
// Proven Goose Pond
// Bend owns the pond physics (and a proof you cannot catch the goose).
// Jev is Destiny: each turn it reads your vibes and picks the paddle.

import * as readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import Game from "../goose/main.bend";
import { hasApiKey, systemOne, mockOracle } from "./jev.mjs";

const DEMO = process.argv.includes("--demo");
const TURNS = Number(process.env.GOOSE_TURNS || (DEMO ? 5 : 10));
const MOVE_MAP = {
  north: "Up",
  south: "Down",
  west: "Left",
  east: "Right",
};

const DEMO_VIBES = [
  "I paddle toward destiny with opera-level confidence",
  "quiet nap energy, maybe west?",
  "THE GOOSE WILL BE MINE; charge the nest walls with pure vibes",
  "casually inspect the lily pads while humming a theorem",
  "dive south because the water looks mathematically suspicious",
];

function one(act) {
  return { $: "Con", head: { $: act }, tail: { $: "Nil" } };
}

function applyMove(state, act) {
  return Game.replay(state, one(act));
}

function pos(g) {
  return { x: Number(g.x), y: Number(g.y), won: Boolean(g.won) };
}

function renderPond(g) {
  const rows = Game.grid(Game.map_h() - 1n).split("\n");
  const { x, y } = pos(g);
  return rows
    .map((row, ry) =>
      row
        .split("")
        .map((ch, cx) => {
          if (cx === x && ry === y) return "🦆";
          if (ch === "F") return "🪿";
          if (ch === "#") return "▓▓";
          if (ch === "P") return "··";
          return "··";
        })
        .join("")
    )
    .join("\n");
}

function banner() {
  return `
╔══════════════════════════════════════════════════════════╗
║           PROVEN GOOSE POND                              ║
║   Bend proves: you cannot catch the Golden Goose.        ║
║   Jev decides: which way your vibes actually paddle.     ║
╚══════════════════════════════════════════════════════════╝
`.trim();
}

function buildQuestions() {
  return {
    paddle: {
      type: "choice",
      instructions:
        "Given the duck's stated vibe and the pond state, which paddle should Destiny apply this turn? Prefer the direction that best matches the vibe's intent; if the vibe is nonsense, pick the most dramatically appropriate compass heading.",
      criteria: {
        north: "Paddle toward decreasing y / up the map",
        south: "Paddle toward increasing y / down the map",
        west: "Paddle toward decreasing x / left",
        east: "Paddle toward increasing x / right",
      },
    },
    goose_smugness: {
      type: "score",
      instructions:
        "How smug does the Golden Goose seem about still being unreachable after this vibe?",
      criteria: [
        "Mildly amused",
        "Visibly smug",
        "Existentially untouchable",
      ],
    },
    feels_like_winning: {
      type: "noul",
      instructions:
        "Does the player's vibe suggest they currently FEEL like they are about to catch the goose / beat the theorem, regardless of whether that is physically possible?",
      criteria: {
        true: "Player radiates imminent-victory energy",
        false: "Player is not projecting a win fantasy",
      },
    },
    narrator_spice: {
      type: "score",
      instructions: "How spicy should the turn narration be?",
      criteria: [
        "Dry field notes",
        "Playful banter",
        "Full opera overture",
      ],
    },
  };
}

function narrate(spice, paddle, bumped, hope, smug) {
  const dir = paddle.toUpperCase();
  if (spice >= 1.7) {
    return bumped
      ? `🎺 Destiny hurls you ${dir} — and the nest wall answers with a theorem-shaped THUD. False hope: ${(hope * 100).toFixed(0)}%. Goose smugness index: ${smug.toFixed(2)}.`
      : `🎺 The choir swells! You surge ${dir} across open water. False hope: ${(hope * 100).toFixed(0)}%. The goose adjusts its crown (smugness ${smug.toFixed(2)}).`;
  }
  if (spice >= 0.9) {
    return bumped
      ? `✨ You vibe ${dir}, kiss a wall, and rebound. Hope dial: ${(hope * 100).toFixed(0)}%.`
      : `✨ You vibe ${dir} and the pond obliges. Hope dial: ${(hope * 100).toFixed(0)}%.`;
  }
  return bumped
    ? `📝 Move=${dir}. Result=wall. hope=${hope.toFixed(2)} smug=${smug.toFixed(2)}`
    : `📝 Move=${dir}. Result=water. hope=${hope.toFixed(2)} smug=${smug.toFixed(2)}`;
}

async function askOracle(statePayload) {
  if (hasApiKey()) {
    return systemOne(statePayload, buildQuestions());
  }
  return mockOracle(statePayload);
}

async function readVibe(rl, turn) {
  if (DEMO) {
    const vibe = DEMO_VIBES[(turn - 1) % DEMO_VIBES.length];
    console.log(`\n[demo vibe] ${vibe}`);
    return vibe;
  }
  const vibe = (await rl.question(`\nTurn ${turn}/${TURNS} — speak your paddle-vibe (or q to quit):\n> `)).trim();
  return vibe;
}

async function main() {
  console.log(banner());
  const usingJev = hasApiKey();
  console.log(
    usingJev
      ? "Oracle: Jev (TYPESAFE_API_KEY detected)"
      : "Oracle: mock stand-in (set TYPESAFE_API_KEY for real Jev)"
  );
  console.log(
    `Bend parallel open-water census: ${Game.open_water()} cells (theorem still holds).`
  );

  let g = Game.start();
  let falseHope = 0;
  let drama = 0;
  let bumps = 0;
  let tokens = 0;

  const rl = DEMO ? null : readline.createInterface({ input, output });

  try {
    for (let turn = 1; turn <= TURNS; turn++) {
      console.log("\n" + renderPond(g));
      const p = pos(g);
      console.log(`Duck @ (${p.x},${p.y})  |  won=${p.won} (Bend says: never)`);

      const vibe = await readVibe(rl, turn);
      if (!vibe) continue;
      if (vibe.toLowerCase() === "q" || vibe.toLowerCase() === "quit") break;

      const payload = {
        game: "Proven Goose Pond",
        turn,
        turns_total: TURNS,
        duck: p,
        won_according_to_bend: p.won,
        theorem: "you_cant_win — no move sequence catches the Golden Goose",
        map_hint:
          "Torus pond with a sealed nest room in the NW. Goose marked F, walls #, open water.",
        player_vibe: vibe,
        score_so_far: { falseHope, drama, bumps },
      };

      process.stdout.write(usingJev ? "Consulting Jev… " : "Consulting mock oracle… ");
      const t0 = Date.now();
      const result = await askOracle(payload);
      const ms = Date.now() - t0;
      console.log(`answered in ${ms}ms via ${result.model}`);

      const paddleKey = result.answers.paddle.choice;
      const act = MOVE_MAP[paddleKey];
      if (!act) throw new Error(`Unexpected paddle: ${paddleKey}`);

      const before = pos(g);
      const next = applyMove(g, act);
      const after = pos(next);
      const bumped = before.x === after.x && before.y === after.y;
      if (bumped) bumps += 1;

      const hope = Number(result.answers.feels_like_winning.noul);
      const smug = Number(result.answers.goose_smugness.score);
      const spice = Number(result.answers.narrator_spice.score);
      const conf = Number(result.answers.paddle.confidence ?? 0);

      // Synergy score: Jev's false hope × confidence, while Bend keeps won=false.
      falseHope += hope * (0.5 + conf);
      drama += spice + smug * 0.25;

      if (result.usage) {
        tokens += Number(result.usage.input_tokens || 0);
      }

      console.log(
        narrate(spice, paddleKey, bumped, hope, smug)
      );
      console.log(
        `  Jev paddle probs: ${JSON.stringify(result.answers.paddle.probabilities)}`
      );
      console.log(
        `  Scores → falseHope=${falseHope.toFixed(2)} drama=${drama.toFixed(2)} bumps=${bumps}`
      );

      g = next;

      if (Game.is_won(g)) {
        // Unreachable if laws hold — if we ever hit this, the theorem broke.
        console.log("\n🚨 IMPOSSIBLE: Bend reported a win. File a bug against reality.");
        process.exitCode = 2;
        return;
      }
    }
  } finally {
    if (rl) rl.close();
  }

  console.log("\n" + renderPond(g));
  console.log(`
══════════════════════════════════════════════════════════
  FINAL REPORT — living proof session complete
──────────────────────────────────────────────────────────
  Bend theorem status : STILL HOLDS (goose uncaught)
  False Hope total    : ${falseHope.toFixed(2)}
  Drama total         : ${drama.toFixed(2)}
  Wall thuds          : ${bumps}
  Jev input tokens    : ${tokens || "(mock)"}
──────────────────────────────────────────────────────────
  Ranking: ${rank(falseHope, drama, bumps)}
══════════════════════════════════════════════════════════
`);
}

function rank(hope, drama, bumps) {
  const score = hope * 2 + drama - bumps * 0.5;
  if (score > 20) return "Chief Witness of Unreachable Geese";
  if (score > 12) return "Senior False-Hope Engineer";
  if (score > 6) return "Pond Intern (vibes department)";
  return "Wet Notebook";
}

main().catch((err) => {
  console.error("\nGame crashed:", err.message || err);
  process.exit(1);
});
