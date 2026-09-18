import Base
import ./src/game.bend as G

# Unite five council seats to become Frog King.
law vote_goal_is_five:
  {G.VOTE_GOAL() == 5 : U32}

law engineer_needs_three_brains:
  {G.BRAIN_NEED() == 3 : U32}

law swamp_has_six_brains:
  {G.brain_count() == 6 : U32}

law grass_is_walkable:
  {G.walkable(0) == True{} : Bool}

law water_is_blocked:
  {G.walkable(1) == False{} : Bool}

law tree_is_blocked:
  {G.walkable(3) == False{} : Bool}

law brain_is_walkable:
  {G.walkable(2) == True{} : Bool}

law warp_is_walkable:
  {G.walkable(11) == True{} : Bool}

law elder_is_npc:
  {G.is_npc(4) == True{} : Bool}

law throne_is_interact:
  {G.is_interact(10) == True{} : Bool}
