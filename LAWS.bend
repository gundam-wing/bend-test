import Base
import ./src/game.bend as G

# Collect 12 fly brains in 120 seconds (7200 frames at 60 Hz).
law goal_is_twelve:
  {G.GOAL() == 12 : U32}

law time_is_two_minutes:
  {G.TIME_LIMIT() == 7200 : U32}

law grass_is_walkable:
  {G.walkable(0) == True{} : Bool}

law water_is_blocked:
  {G.walkable(1) == False{} : Bool}

law tree_is_blocked:
  {G.walkable(3) == False{} : Bool}

law brain_is_walkable:
  {G.walkable(2) == True{} : Bool}

law twelve_brains_on_map:
  {G.brain_count() == 12 : U32}
