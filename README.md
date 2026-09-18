# Proven Goose Pond

**Bend** proves you can never catch the Golden Goose.  
**Jev** (TypeSafe System One) reads your vibes and decides which way you paddle anyway.

A tiny silly game about the synergy between:

| Tool | Job in this pond |
| --- | --- |
| [Bend](https://github.com/bendlang/bend) | Parallel, proof-checked world physics. `LAWS.bend` states *winning is impossible*; `PROOF.bend` is the certificate. |
| [Jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev) | Fast typed decisions over game state: paddle choice, goose smugness, false-hope probability, narrator spice — all in one parallel call. |

Bend is the theorem. Jev is Destiny. You are a duck with opinions.

## Play

```bash
# once
curl -fsSL https://bend-lang.com/install.sh | sh
# bun: https://bun.sh

export TYPESAFE_API_KEY=...   # GitHub secret name in CI: TYPESAFE_API_KEY
./host/play.sh                # interactive
./host/play.sh --demo         # scripted vibes (great for CI)
```

Without a key, a mock oracle still runs so you can feel the loop.

## Check the theorem

```bash
export PATH="$HOME/.bend/bin:$PATH"
bend goose/PROOF.bend     # must print: All terms check.
bend goose/main.bend      # prints the pond + parallel open-water census
```

## What each turn asks Jev

One System One request, four questions in parallel:

1. **Choice** `paddle` — north / south / east / west from your free-text vibe  
2. **Score** `goose_smugness` — how untouchable the goose feels  
3. **Noul** `feels_like_winning` — your false hope (0..1)  
4. **Score** `narrator_spice` — dry notes vs opera overture  

Bend then applies the paddle. Walls thud. The goose stays unreachable. Your score is mostly accumulated *false hope* — the comedy of calibrated Destiny colliding with a proved invariant.

## Layout

```
goose/          Bend world + laws + proofs
host/play.mjs   CLI host (imports goose/main.bend via Bun)
host/jev.mjs    TypeSafe HTTP client + mock oracle
host/play.sh    Resolves Bend loader path, launches the game
```

## CI

`.github/workflows/goose.yml` installs Bend, checks `PROOF.bend`, then runs `--demo` with `TYPESAFE_API_KEY` from the repo's **`main` Environment** secrets.

## Credits

Pond geometry and the `you_cant_win` certificate are adapted from Bend's
[Winning Is Impossible](https://github.com/bendlang/bend/tree/main/demos/app_win_is_bug_2d) demo — the point of this repo is the Jev Destiny layer on top of that proof-shaped world.
