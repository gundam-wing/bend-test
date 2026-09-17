import Base
import ./game.bend as G

def px_of(m: Maybe<G.Game>) -> U32:
  match m:
    case None{}:
      0
    case Some{g}:
      G.pos_x(g)

def tap_d() -> U32:
  px_of(G.step(
    Con{Key{100, True{}}, Con{Key{100, False{}}, Nil{}}},
    G.start()
  ))

def main() -> String:
  "brains=" ++ U32.show(G.brain_count()) ++ " goal=" ++ U32.show(G.GOAL()) ++
    " time=" ++ U32.show(G.TIME_LIMIT()) ++ " tapD=" ++ U32.show(tap_d())
