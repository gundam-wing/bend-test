When using Bend:
- run `bend guide` to learn it
- use `goose/LAWS.bend` to keep important rules
- run `bend goose/PROOF.bend` before committing
- parallelize the code whenever possible

This repo is a synergy demo:
- Bend owns proven pond physics (`goose/`)
- Jev (TypeSafe System One) owns fuzzy Destiny decisions (`host/`)
- Do not weaken laws in `goose/LAWS.bend`
- Prefer `TYPESAFE_API_KEY` from the environment / GitHub Actions secrets
