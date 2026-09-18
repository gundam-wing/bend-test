# Frog King

A Pokémon-style story map written in [Bend](https://bend-lang.com/). You are **Ribbit the Frog Wizard**. Walk connected regions, talk to council characters, and build **consensus** to rule as Frog King — ushering in a new age of grand technological progress.

## Story

1. **Lily Pad Village** — Elder Lily opens the council road. Merchant Tad waits by the reeds.
2. **Copper Cog Lab** — Engineer Toad needs **3 fly brains** from the swamp for the Grand Diffuser.
3. **Reed Swamp** — Gather brains, earn Captain Newt’s shield-vote.
4. **Mist Shrine** — Oracle Sal joins once Engineer and Captain have spoken for you.
5. Return to Elder Lily for the fifth vote, then claim the **Throne Hall**.

Cyan warp pads link the maps (village ↔ swamp ↔ shrine, village ↔ lab, throne south gate).

## Install Bend

```bash
curl -fsSL https://bend-lang.com/install.sh | sh
```

On Linux a native window needs `libx11-dev`. Then open a new shell (or add `~/.bend/bin` to `PATH`).

## Play

Native (60 Hz window):

```bash
bend src/game.bend -o frog-king
./frog-king
```

Or `./play.sh`.

Browser:

```bash
bend src/index.html -o dist
```

Serve the `dist` folder and open the page. The browser build shows a dialogue box with full story text.

### Controls

- **WASD** / **arrows** — walk
- **Space** / **Z** / **Enter** — talk / advance dialogue / leave title
- **R** — restart
- **Esc** — quit (native)

Face a character (or the throne) and press Space. Hold a direction while talking to choose whom you address when several stand near.

### HUD

Top row: five council vote slots, then three brain slots for the Engineer’s quest.

## Project layout

- `src/sprites.bend` — frog, NPCs, brains, warps, throne, tiles, talk/title/win art
- `src/game.bend` — five maps, movement, warps, dialogue state, consensus flags, `App.run`
- `src/index.html` / `src/play.js` — canvas player + story dialogue overlay
- `src/test.bend` — smoke checks
- `LAWS.bend` / `PROOF.bend` — Bend laws for vote goal, brains, walkability, NPCs
- `AGENTS.md` — Bend agent conventions

```bash
bend src/test.bend
bend PROOF.bend
```
