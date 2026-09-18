import Base
import ./game.bend as G

def px_of(m: Maybe<G.Game>) -> U32:
  match m:
    case None{}:
      0
    case Some{g}:
      G.pos_x(g)

def votes_of(m: Maybe<G.Game>) -> U32:
  match m:
    case None{}:
      0
    case Some{g}:
      G.votes_of(g)

def tap_space() -> U32:
  # Leave title screen.
  px_of(G.step(Con{Key{32, True{}}, Nil{}}, G.start()))

def main() -> String:
  "votes=" ++ U32.show(G.VOTE_GOAL()) ++ " brains_need=" ++
    U32.show(G.BRAIN_NEED()) ++ " swamp_brains=" ++
    U32.show(G.brain_count()) ++ " leave_title_px=" ++ U32.show(tap_space())
