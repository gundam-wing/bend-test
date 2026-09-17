import Base
import ./game.bend as G

def main() -> String:
  "brains=" ++ U32.show(G.brain_count()) ++ " goal=" ++ U32.show(G.GOAL()) ++
    " time=" ++ U32.show(G.TIME_LIMIT())
