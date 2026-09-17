# Frog Wizard

A tiny retro pixel-art game written in [Bend](https://bend-lang.com/). You are a frog wizard. Walk a swamp tilemap, collect **12 fly brains**, and beat the **2 minute** clock.

## Install Bend

```bash
curl -fsSL https://bend-lang.com/install.sh | sh
```

On Linux a native window needs `libx11-dev`. Then open a new shell (or add `~/.bend/bin` to `PATH`).

## Play

Native (60 Hz X11 / AppKit window):

```bash
bend src/game.bend -o frog-wizard
./frog-wizard
```

Browser:

```bash
bend src/index.html -o dist
```

Serve the `dist` folder and open the page.

### Controls

- **WASD** or **arrow keys** — walk one tile at a time (click the window first so it has keyboard focus)
- **R** — restart
- **Esc** / close window — quit (native)

Taps count: a press and release in the same frame still moves one tile. Hold a key to keep walking.

### How to win

The top row is the HUD: twelve brain slots fill as you collect, and the right-hand bar is the remaining time (green → yellow → red). Gather every fly brain before the bar empties. A win screen shows a giant frog wizard; running out of time shows a missed brain.

## Project layout

- `src/sprites.bend` — frog-wizard sprite, fly-brain sprite, grass / water / tree tiles, HUD
- `src/game.bend` — 16×16 tilemap, movement, collecting, 7200-frame timer, `App.run`
- `src/index.html` — canvas player that imports the Bend game
- `src/test.bend` — checks that the map has 12 brains
- `LAWS.bend` / `PROOF.bend` — Bend laws: 12 brains, 2 minute limit, walkable tiles
- `AGENTS.md` — Bend agent conventions from [bend-lang.com](https://bend-lang.com/)

```bash
bend src/test.bend     # prints brains=12 goal=12 time=7200
bend PROOF.bend        # All terms check.
```
