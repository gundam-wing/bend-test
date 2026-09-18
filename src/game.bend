# Frog King: Pokémon-style map story. Unite five council seats to rule
# and usher in an age of grand technological progress.
import Base
import ./sprites.bend as Spr

type Mode is Data:
  Title{}
  Play{}
  Talk{}
  Win{}

type Dir is Data:
  Stay{}
  Left{}
  Right{}
  Up{}
  Down{}

# allies bits: 1 elder, 2 engineer, 4 captain, 8 merchant, 16 oracle
# flags bits: 1 intro, 2 brains_delivered, 4 shrine_seen, 8 throne_open
type Game is Type:
  Game{
    tiles: Array<U32>,
    map_id: U32,
    px: U32,
    py: U32,
    brains: U32,
    votes: U32,
    allies: U32,
    flags: U32,
    talk_npc: U32,
    talk_step: U32,
    cool: U32,
    left: Bool,
    right: Bool,
    up: Bool,
    down: Bool,
    mode: Mode
  }

def VOTE_GOAL() -> U32:
  5

def BRAIN_NEED() -> U32:
  3

def STEP_COOL() -> U32:
  8

def MAP_W() -> U32:
  16

# Tile kinds:
# 0 grass, 1 water, 2 brain, 3 tree, 4 elder, 5 engineer, 6 captain,
# 7 merchant, 8 oracle, 9 wall, 10 throne, 11 warp, 12 floor
def walkable(+kind: U32) -> Bool:
  Bool.or(U32.is_eq(kind, 0),
    Bool.or(U32.is_eq(kind, 2),
      Bool.or(U32.is_eq(kind, 11), U32.is_eq(kind, 12))))

def is_npc(+kind: U32) -> Bool:
  Bool.and(U32.is_ge(kind, 4), U32.is_le(kind, 8))

def is_interact(+kind: U32) -> Bool:
  Bool.or(is_npc(kind), U32.is_eq(kind, 10))

def npc_id_of(+kind: U32) -> U32:
  Bool.pick(U32, U32.is_eq(kind, 4), 1,
    Bool.pick(U32, U32.is_eq(kind, 5), 2,
      Bool.pick(U32, U32.is_eq(kind, 6), 3,
        Bool.pick(U32, U32.is_eq(kind, 7), 4,
          Bool.pick(U32, U32.is_eq(kind, 8), 5,
            Bool.pick(U32, U32.is_eq(kind, 10), 6, 0))))))

def bit_has(+bits: U32, +mask: U32) -> Bool:
  U32.is_ne(U32.and(bits, mask), 0)

def bit_set(+bits: U32, +mask: U32) -> U32:
  U32.or(bits, mask)

def paint(xs: List<&2, U32>, a: Array<U32>, +v: U32) -> Array<U32>:
  match xs:
    case Nil{}:
      a
    case Con{i, t}:
      paint(t, Array.set(U32, a, i, v), v)

def BORDER() -> List<&2, U32>:
  [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 31, 32, 47,
    48, 63, 64, 79, 80, 95, 96, 111, 112, 127, 128, 143, 144, 159, 160, 175,
    176, 191, 192, 207, 208, 223, 224, 239, 240, 241, 242, 243, 244, 245,
    246, 247, 248, 249, 250, 251, 252, 253, 254, 255
  ]

# Map 0 — Lily Pad Village: Elder (4), Merchant (7), warps south & east
def V0_WATER() -> List<&2, U32>:
  [34, 35, 36, 50, 51, 52]

def V0_TREE() -> List<&2, U32>:
  [68, 69, 84, 100, 116, 132, 148]

def V0_NPC() -> List<&2, U32>:
  [55, 185]

def V0_WARP() -> List<&2, U32>:
  [25, 157, 231]

def map_village() -> Array<U32>:
  paint(V0_WARP(), paint([55], paint([185], paint(V0_TREE(),
    paint(V0_WATER(), paint(BORDER(), [0 : U32^8n], 9), 1), 3), 7), 4), 11)

# Map 1 — Reed Swamp: brains, Captain (6), warp west back / east to shrine
def V1_WATER() -> List<&2, U32>:
  [
    34, 35, 36, 43, 44, 45, 50, 51, 52, 59, 60, 61, 162, 163, 164, 171, 172,
    173, 178, 179, 180, 187, 188, 189
  ]

def V1_TREE() -> List<&2, U32>:
  [87, 88, 89, 90, 103, 106, 119, 121, 135, 136, 137, 138]

def V1_BRAIN() -> List<&2, U32>:
  [29, 55, 83, 93, 114, 141]

def V1_NPC() -> List<&2, U32>:
  [120]

def V1_WARP() -> List<&2, U32>:
  [146, 157]

def map_swamp() -> Array<U32>:
  paint(V1_WARP(), paint(V1_NPC(), paint(V1_BRAIN(), paint(V1_TREE(),
    paint(V1_WATER(), paint(BORDER(), [0 : U32^8n], 9), 1), 3), 2), 6), 11)

# Map 2 — Copper Cog Lab: Engineer (5), floor, warp south to village
def V2_FLOOR() -> List<&2, U32>:
  [
    49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62,
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
    81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
    113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126,
    129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142,
    145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158,
    161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174,
    177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190,
    193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206,
    209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222
  ]

def map_lab() -> Array<U32>:
  paint([231], paint([88], paint(V2_FLOOR(), paint(BORDER(), [0 : U32^8n], 9),
    12), 5), 11)

# Map 3 — Mist Shrine: Oracle (8), warp west to swamp
def V3_WATER() -> List<&2, U32>:
  [50, 51, 52, 58, 59, 60, 66, 76, 82, 92, 98, 108, 114, 124]

def V3_TREE() -> List<&2, U32>:
  [67, 68, 69, 70, 71, 72, 73, 74, 75, 83, 84, 85, 86, 87, 88, 89, 90, 91]

def map_shrine() -> Array<U32>:
  paint([146], paint([120], paint(V3_TREE(), paint(V3_WATER(),
    paint(BORDER(), [0 : U32^8n], 9), 1), 3), 8), 11)

# Map 4 — Throne Hall: Throne (10), warp south (locked until votes==5 via flag)
def V4_FLOOR() -> List<&2, U32>:
  [
    49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62,
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78,
    81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
    113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126,
    129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142,
    145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158,
    161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174,
    177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190,
    193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206,
    209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222
  ]

def map_throne() -> Array<U32>:
  paint([231], paint([72], paint(V4_FLOOR(), paint(BORDER(), [0 : U32^8n], 9),
    12), 10), 11)

def tiles_of_throne_on(z: Bool) -> Array<U32>:
  match z:
    case True{}:
      map_shrine()
    case False{}:
      map_throne()

def tiles_of_lab_on(+map_id: U32, z: Bool) -> Array<U32>:
  match z:
    case True{}:
      map_lab()
    case False{}:
      tiles_of_throne_on(U32.is_eq(map_id, 3))

def tiles_of_swamp_on(+map_id: U32, z: Bool) -> Array<U32>:
  match z:
    case True{}:
      map_swamp()
    case False{}:
      tiles_of_lab_on(map_id, U32.is_eq(map_id, 2))

def tiles_of_on(+map_id: U32, z: Bool) -> Array<U32>:
  match z:
    case True{}:
      map_village()
    case False{}:
      tiles_of_swamp_on(map_id, U32.is_eq(map_id, 1))

def tiles_of(+map_id: U32) -> Array<U32>:
  tiles_of_on(map_id, U32.is_eq(map_id, 0))

def brain_count() -> U32:
  6

def start() -> Game:
  Game{
    map_village(), 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, False{}, False{}, False{},
    False{}, Title{}
  }

def pos_x(g: Game) -> U32:
  Game{tiles, map_id, +px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  px

def votes_of(g: Game) -> U32:
  Game{tiles, map_id, px, py, brains, +votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  votes

def mode_tag(mode: Mode) -> U32:
  match mode:
    case Title{}:
      0
    case Play{}:
      1
    case Talk{}:
      2
    case Win{}:
      3

def peek_mode(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, +mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    mode_tag(mode)
  )

def peek_talk_npc(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, +talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    talk_npc
  )

def peek_talk_step(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    +talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    talk_step
  )

def peek_votes(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, +votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    votes
  )

def peek_brains(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, +brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    brains
  )

def peek_allies(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, votes, +allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    allies
  )

def peek_flags(g: Game) -> Game & U32:
  Game{tiles, map_id, px, py, brains, votes, allies, +flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    flags
  )

def peek_map(g: Game) -> Game & U32:
  Game{tiles, +map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    map_id
  )

def dec_sat(+x: U32) -> U32:
  Bool.pick(U32, U32.is_eq(x, 0), 0, (x - 1 : U32))

def inc_sat(+x: U32) -> U32:
  Bool.pick(U32, U32.is_eq(x, 15), 15, (x + 1 : U32))

def pick_down(down: Bool) -> Dir:
  match down:
    case True{}:
      Down{}
    case False{}:
      Stay{}

def pick_vert(up: Bool, down: Bool) -> Dir:
  match up:
    case True{}:
      Up{}
    case False{}:
      pick_down(down)

def pick_right(right: Bool, up: Bool, down: Bool) -> Dir:
  match right:
    case True{}:
      Right{}
    case False{}:
      pick_vert(up, down)

def pick_dir(left: Bool, right: Bool, up: Bool, down: Bool) -> Dir:
  match left:
    case True{}:
      Left{}
    case False{}:
      pick_right(right, up, down)

def warp_dest_throne(z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      (1, 13, 8)
    case False{}:
      (0, 8, 13)

def warp_dest_lab(+map_id: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      (0, 8, 2)
    case False{}:
      warp_dest_throne(U32.is_eq(map_id, 3))

def warp_dest_swamp_idx(+idx: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      (0, 13, 8)
    case False{}:
      (3, 2, 8)

def warp_dest_swamp(+map_id: U32, +idx: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      warp_dest_swamp_idx(idx, U32.is_eq(idx, 146))
    case False{}:
      warp_dest_lab(map_id, U32.is_eq(map_id, 2))

def warp_dest_village_lab(+idx: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      (2, 8, 13)
    case False{}:
      (1, 2, 8)

def warp_dest_village(+idx: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      (4, 8, 13)
    case False{}:
      warp_dest_village_lab(idx, U32.is_eq(idx, 157))

def warp_dest_on(+map_id: U32, +idx: U32, z: Bool) -> U32 & U32 & U32:
  match z:
    case True{}:
      warp_dest_village(idx, U32.is_eq(idx, 25))
    case False{}:
      warp_dest_swamp(map_id, idx, U32.is_eq(map_id, 1))

def warp_dest(+map_id: U32, +idx: U32) -> U32 & U32 & U32:
  warp_dest_on(map_id, idx, U32.is_eq(map_id, 0))

def apply_warp_at(
  dest: U32 & U32 & U32, brains: U32, votes: U32, allies: U32, flags: U32,
  left: Bool, right: Bool, up: Bool, down: Bool
) -> Game:
  (+nid, nx, ny) = dest
  Game{
    tiles_of(nid), nid, nx, ny, brains, votes, allies, flags, 0, 0,
    STEP_COOL(), left, right, up, down, Play{}
  }

def apply_warp(
  +map_id: U32, +idx: U32, brains: U32, votes: U32, allies: U32, flags: U32,
  left: Bool, right: Bool, up: Bool, down: Bool
) -> Game:
  apply_warp_at(warp_dest(map_id, idx), brains, votes, allies, flags, left,
    right, up, down)

def grant_ally(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  +votes: U32, +allies: U32, flags: U32, +mask: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, already: Bool
) -> Game:
  match already:
    case True{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}
    case False{}:
      Game{tiles, map_id, px, py, brains, (votes + 1 : U32),
        bit_set(allies, mask), flags, 0, 0, STEP_COOL(), left, right, up,
        down, Play{}}

def finish_talk_elder_ready(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  +votes: U32, +allies: U32, +flags2: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ready: Bool
) -> Game:
  match ready:
    case True{}:
      grant_ally(tiles, map_id, px, py, brains, votes, allies,
        bit_set(flags2, 8), 1, left, right, up, down, bit_has(allies, 1))
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags2, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_elder_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  +votes: U32, allies: U32, flags2: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_elder_ready(tiles, map_id, px, py, brains, votes, allies,
    flags2, left, right, up, down, U32.is_ge(votes, 4))

def finish_talk_elder(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, +flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_elder_on(tiles, map_id, px, py, brains, votes, allies,
    bit_set(flags, 1), left, right, up, down)

def finish_talk_engineer_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, +brains: U32,
  votes: U32, +allies: U32, +flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ok: Bool
) -> Game:
  match ok:
    case True{}:
      grant_ally(tiles, map_id, px, py, 0, votes, allies, bit_set(flags, 2),
        2, left, right, up, down, bit_has(allies, 2))
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_engineer(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, +brains: U32,
  votes: U32, allies: U32, +flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_engineer_on(tiles, map_id, px, py, brains, votes, allies,
    flags, left, right, up, down,
    Bool.and(bit_has(flags, 1), U32.is_ge(brains, BRAIN_NEED())))

def finish_talk_captain_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, +allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ok: Bool
) -> Game:
  match ok:
    case True{}:
      grant_ally(tiles, map_id, px, py, brains, votes, allies, flags, 4,
        left, right, up, down, bit_has(allies, 4))
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_captain(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, +flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_captain_on(tiles, map_id, px, py, brains, votes, allies, flags,
    left, right, up, down, bit_has(flags, 1))

def finish_talk_merchant_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, +allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ok: Bool
) -> Game:
  match ok:
    case True{}:
      grant_ally(tiles, map_id, px, py, brains, votes, allies, flags, 8,
        left, right, up, down, bit_has(allies, 8))
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_merchant(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, +allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_merchant_on(tiles, map_id, px, py, brains, votes, allies,
    flags, left, right, up, down, bit_has(allies, 2))

def finish_talk_oracle_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, +allies: U32, +flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ok: Bool
) -> Game:
  match ok:
    case True{}:
      grant_ally(tiles, map_id, px, py, brains, votes, allies,
        bit_set(flags, 4), 16, left, right, up, down, bit_has(allies, 16))
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_oracle(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, +allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_oracle_on(tiles, map_id, px, py, brains, votes, allies, flags,
    left, right, up, down, Bool.and(bit_has(allies, 2), bit_has(allies, 4)))

def finish_talk_throne_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  +votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, ok: Bool
) -> Game:
  match ok:
    case True{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Win{}}
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def finish_talk_throne(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  +votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool
) -> Game:
  finish_talk_throne_on(tiles, map_id, px, py, brains, votes, allies, flags,
    left, right, up, down, U32.is_ge(votes, VOTE_GOAL()))

def finish_talk_npc5(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, z: Bool
) -> Game:
  match z:
    case True{}:
      finish_talk_oracle(tiles, map_id, px, py, brains, votes, allies, flags,
        left, right, up, down)
    case False{}:
      finish_talk_throne(tiles, map_id, px, py, brains, votes, allies, flags,
        left, right, up, down)

def finish_talk_npc4(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +npc: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, z: Bool
) -> Game:
  match z:
    case True{}:
      finish_talk_merchant(tiles, map_id, px, py, brains, votes, allies,
        flags, left, right, up, down)
    case False{}:
      finish_talk_npc5(tiles, map_id, px, py, brains, votes, allies, flags,
        left, right, up, down, U32.is_eq(npc, 5))

def finish_talk_npc3(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +npc: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, z: Bool
) -> Game:
  match z:
    case True{}:
      finish_talk_captain(tiles, map_id, px, py, brains, votes, allies,
        flags, left, right, up, down)
    case False{}:
      finish_talk_npc4(tiles, map_id, px, py, brains, votes, allies, flags,
        npc, left, right, up, down, U32.is_eq(npc, 4))

def finish_talk_npc2(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +npc: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, z: Bool
) -> Game:
  match z:
    case True{}:
      finish_talk_engineer(tiles, map_id, px, py, brains, votes, allies,
        flags, left, right, up, down)
    case False{}:
      finish_talk_npc3(tiles, map_id, px, py, brains, votes, allies, flags,
        npc, left, right, up, down, U32.is_eq(npc, 3))

def finish_talk_npc1(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +npc: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, z: Bool
) -> Game:
  match z:
    case True{}:
      finish_talk_elder(tiles, map_id, px, py, brains, votes, allies, flags,
        left, right, up, down)
    case False{}:
      finish_talk_npc2(tiles, map_id, px, py, brains, votes, allies, flags,
        npc, left, right, up, down, U32.is_eq(npc, 2))

def finish_talk_npc(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +npc: U32, left: Bool, right: Bool,
  up: Bool, down: Bool
) -> Game:
  finish_talk_npc1(tiles, map_id, px, py, brains, votes, allies, flags, npc,
    left, right, up, down, U32.is_eq(npc, 1))

def advance_talk_on(
  tiles: Array<U32>, +map_id: U32, +px: U32, +py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, +talk_npc: U32, +next: U32,
  cool: U32, left: Bool, right: Bool, up: Bool, down: Bool, done: Bool
) -> Game:
  match done:
    case True{}:
      finish_talk_npc(tiles, map_id, px, py, brains, votes, allies, flags,
        talk_npc, left, right, up, down)
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
        next, cool, left, right, up, down, Talk{}}

def advance_talk(g: Game) -> Game:
  Game{tiles, +map_id, +px, +py, brains, votes, allies, flags, +talk_npc,
    +talk_step, cool, left, right, up, down, mode} = g
  advance_talk_on(tiles, map_id, px, py, brains, votes, allies, flags,
    talk_npc, (talk_step + 1 : U32), cool, left, right, up, down,
    U32.is_ge((talk_step + 1 : U32), 3))

def begin_talk(g: Game, +npc: U32) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, npc, 0, cool,
    left, right, up, down, Talk{}}

def try_interact_got_on(
  +map_id: U32, +px: U32, +py: U32, brains: U32, votes: U32, allies: U32,
  flags: U32, talk_npc: U32, talk_step: U32, cool: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, mode: Mode, tiles: Array<U32>,
  +kind: U32, hit: Bool
) -> Game:
  match hit:
    case True{}:
      begin_talk(
        Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
          talk_step, cool, left, right, up, down, mode},
        npc_id_of(kind)
      )
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
        talk_step, cool, left, right, up, down, mode}

def try_interact_got(
  +map_id: U32, +px: U32, +py: U32, brains: U32, votes: U32, allies: U32,
  flags: U32, talk_npc: U32, talk_step: U32, cool: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, mode: Mode, r: Array<U32> & U32
) -> Game:
  (tiles, +kind) = r
  try_interact_got_on(map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode, tiles, kind,
    is_interact(kind))

def try_interact_at(g: Game, +tx: U32, +ty: U32) -> Game:
  Game{tiles, +map_id, +px, +py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  try_interact_got(map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode,
    Array.get(U32, tiles, (ty * 16 + tx : U32)))

def try_interact_dir(g: Game, +px: U32, +py: U32, dir: Dir) -> Game:
  match dir:
    case Stay{}:
      try_interact_at(g, px, dec_sat(py))
    case Left{}:
      try_interact_at(g, dec_sat(px), py)
    case Right{}:
      try_interact_at(g, inc_sat(px), py)
    case Up{}:
      try_interact_at(g, px, dec_sat(py))
    case Down{}:
      try_interact_at(g, px, inc_sat(py))

def try_interact(g: Game) -> Game:
  Game{tiles, map_id, +px, +py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, +left, +right, +up, +down, mode} = g
  try_interact_dir(
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    px, py, pick_dir(left, right, up, down)
  )

def pickup_on(
  tiles: Array<U32>, +map_id: U32, +nx: U32, +ny: U32, +brains: U32,
  votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, brain: Bool
) -> Game:
  match brain:
    case True{}:
      Game{Array.set(U32, tiles, (ny * 16 + nx : U32), 0), map_id, nx, ny,
        (brains + 1 : U32), votes, allies, flags, 0, 0, STEP_COOL(), left,
        right, up, down, Play{}}
    case False{}:
      Game{tiles, map_id, nx, ny, brains, votes, allies, flags, 0, 0,
        STEP_COOL(), left, right, up, down, Play{}}

def enter_cell_on(
  tiles: Array<U32>, +map_id: U32, +nx: U32, +ny: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, +kind: U32, warp: Bool
) -> Game:
  match warp:
    case True{}:
      apply_warp(map_id, (ny * 16 + nx : U32), brains, votes, allies, flags,
        left, right, up, down)
    case False{}:
      pickup_on(tiles, map_id, nx, ny, brains, votes, allies, flags, left,
        right, up, down, U32.is_eq(kind, 2))

def enter_cell(
  tiles: Array<U32>, +map_id: U32, +nx: U32, +ny: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, left: Bool, right: Bool, up: Bool,
  down: Bool, +kind: U32
) -> Game:
  enter_cell_on(tiles, map_id, nx, ny, brains, votes, allies, flags, left,
    right, up, down, kind, U32.is_eq(kind, 11))

def nudge_kind(
  tiles: Array<U32>, +map_id: U32, +nx: U32, +ny: U32, px: U32, py: U32,
  brains: U32, votes: U32, allies: U32, flags: U32, cool: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, mode: Mode, +kind: U32, ok: Bool
) -> Game:
  match ok:
    case True{}:
      enter_cell(tiles, map_id, nx, ny, brains, votes, allies, flags, left,
        right, up, down, kind)
    case False{}:
      Game{tiles, map_id, px, py, brains, votes, allies, flags, 0, 0, cool,
        left, right, up, down, mode}

def nudge_got(
  +map_id: U32, +nx: U32, +ny: U32, px: U32, py: U32, brains: U32,
  votes: U32, allies: U32, flags: U32, cool: U32, left: Bool, right: Bool,
  up: Bool, down: Bool, mode: Mode, r: Array<U32> & U32
) -> Game:
  (tiles, +kind) = r
  nudge_kind(tiles, map_id, nx, ny, px, py, brains, votes, allies, flags,
    cool, left, right, up, down, mode, kind, walkable(kind))

def nudge(g: Game, +nx: U32, +ny: U32) -> Game:
  Game{tiles, +map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  nudge_got(map_id, nx, ny, px, py, brains, votes, allies, flags, cool,
    left, right, up, down, mode, Array.get(U32, tiles, (ny * 16 + nx : U32)))

def try_move_dir(g: Game, +px: U32, +py: U32, dir: Dir) -> Game:
  match dir:
    case Stay{}:
      g
    case Left{}:
      nudge(g, dec_sat(px), py)
    case Right{}:
      nudge(g, inc_sat(px), py)
    case Up{}:
      nudge(g, px, dec_sat(py))
    case Down{}:
      nudge(g, px, inc_sat(py))

def try_move(g: Game, dir: Dir) -> Game:
  Game{tiles, map_id, +px, +py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  try_move_dir(
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    px, py, dir
  )

def set_cool(g: Game, cool2: U32) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool2, left, right, up, down, mode}

def frame_cool_on(
  g: Game, +left: Bool, +right: Bool, +up: Bool, +down: Bool, +cool: U32,
  ready: Bool
) -> Game:
  match ready:
    case True{}:
      try_move(g, pick_dir(left, right, up, down))
    case False{}:
      set_cool(g, (cool - 1 : U32))

def frame_cool(
  g: Game, +cool: U32, +left: Bool, +right: Bool, +up: Bool, +down: Bool
) -> Game:
  frame_cool_on(g, left, right, up, down, cool, U32.is_eq(cool, 0))

def frame_play(g: Game) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, +cool, +left, +right, +up, +down, mode} = g
  frame_cool(
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    cool, left, right, up, down
  )

def frame_mode(g: Game, mode: Mode) -> Game:
  match mode:
    case Title{}:
      g
    case Play{}:
      frame_play(g)
    case Talk{}:
      g
    case Win{}:
      g

def frame(g: Game) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, +mode} = g
  frame_mode(
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    mode
  )

def set_left(g: Game, pressed: Bool) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, pressed, right, up, down, mode}

def set_right(g: Game, pressed: Bool) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, pressed, up, down, mode}

def set_up(g: Game, pressed: Bool) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, pressed, down, mode}

def set_down(g: Game, pressed: Bool) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, pressed, mode}

def hold_move(g: Game, +pressed: Bool, dir: Dir) -> Game:
  match pressed:
    case True{}:
      try_move(g, dir)
    case False{}:
      g

def hold_left(g: Game, +pressed: Bool) -> Game:
  hold_move(set_left(g, pressed), pressed, Left{})

def hold_right(g: Game, +pressed: Bool) -> Game:
  hold_move(set_right(g, pressed), pressed, Right{})

def hold_up(g: Game, +pressed: Bool) -> Game:
  hold_move(set_up(g, pressed), pressed, Up{})

def hold_down(g: Game, +pressed: Bool) -> Game:
  hold_move(set_down(g, pressed), pressed, Down{})

def key_is(+code: U32, +a: U32, +b: U32) -> Bool:
  Bool.or(U32.is_eq(code, a), U32.is_eq(code, b))

def key_is3(+code: U32, +a: U32, +b: U32, +c: U32) -> Bool:
  Bool.or(U32.is_eq(code, a), key_is(code, b, c))

def apply_arrow_d(code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_down(g, pressed)
    case False{}:
      g

def apply_arrow_u(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_up(g, pressed)
    case False{}:
      apply_arrow_d(code, pressed, g, key_is3(code, 63233, 65652, 116))

def apply_arrow_r(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_right(g, pressed)
    case False{}:
      apply_arrow_u(code, pressed, g, key_is3(code, 63232, 65647, 111))

def apply_arrow_l(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_left(g, pressed)
    case False{}:
      apply_arrow_r(code, pressed, g, key_is(code, 63235, 65650))

def apply_downk(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_down(g, pressed)
    case False{}:
      apply_arrow_l(code, pressed, g, key_is(code, 63234, 65649))

def apply_up(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_up(g, pressed)
    case False{}:
      apply_downk(code, pressed, g, key_is(code, 115, 65575))

def apply_right(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_right(g, pressed)
    case False{}:
      apply_up(code, pressed, g, key_is(code, 119, 65561))

def apply_left(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      hold_left(g, pressed)
    case False{}:
      apply_right(code, pressed, g, key_is(code, 100, 65576))

def to_play(g: Game) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, Play{}}

def apply_restart(pressed: Bool, g: Game) -> Game:
  match pressed:
    case True{}:
      start()
    case False{}:
      g

def confirm_title(pressed: Bool, g: Game) -> Game:
  match pressed:
    case True{}:
      to_play(g)
    case False{}:
      g

def confirm_talk(pressed: Bool, g: Game) -> Game:
  match pressed:
    case True{}:
      advance_talk(g)
    case False{}:
      g

def confirm_play(pressed: Bool, g: Game) -> Game:
  match pressed:
    case True{}:
      try_interact(g)
    case False{}:
      g

def apply_confirm_mode(pressed: Bool, g: Game, mode: Mode) -> Game:
  match mode:
    case Title{}:
      confirm_title(pressed, g)
    case Talk{}:
      confirm_talk(pressed, g)
    case Play{}:
      confirm_play(pressed, g)
    case Win{}:
      apply_restart(pressed, g)

def apply_confirm(pressed: Bool, g: Game) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, +mode} = g
  apply_confirm_mode(pressed,
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    mode)

def apply_z(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      apply_confirm(pressed, g)
    case False{}:
      apply_left(code, pressed, g, key_is(code, 97, 65574))

def apply_space(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      apply_confirm(pressed, g)
    case False{}:
      apply_z(code, pressed, g, key_is(code, 122, 65571))

def apply_enter(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      apply_confirm(pressed, g)
    case False{}:
      apply_space(code, pressed, g, U32.is_eq(code, 32))

def apply_r(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      apply_restart(pressed, g)
    case False{}:
      apply_enter(code, pressed, g, key_is(code, 13, 65293))

def apply_key_play(+code: U32, pressed: Bool, g: Game) -> Game:
  apply_r(code, pressed, g, key_is(code, 114, 65563))

def apply_key_mode(+code: U32, pressed: Bool, g: Game, mode: Mode) -> Game:
  match mode:
    case Title{}:
      confirm_title(pressed, g)
    case Talk{}:
      confirm_talk(pressed, g)
    case Win{}:
      apply_restart(pressed, g)
    case Play{}:
      apply_key_play(code, pressed, g)

def apply_key(+code: U32, pressed: Bool, g: Game) -> Game:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, +mode} = g
  apply_key_mode(code, pressed,
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    mode)

# Drawing
def cell_frog_on(+kind: U32, frog: Bool) -> Image:
  match frog:
    case True{}:
      Spr.frog_on(Spr.tile_of(kind))
    case False{}:
      Spr.tile_of(kind)

def cell_frog(+kind: U32, +tx: U32, +ty: U32, +px: U32, +py: U32) -> Image:
  cell_frog_on(kind, Bool.and(U32.is_eq(tx, px), U32.is_eq(ty, py)))

def cell_hud(
  +kind: U32, +tx: U32, +ty: U32, +px: U32, +py: U32, +votes: U32,
  +brains: U32, hud: Bool
) -> Image:
  match hud:
    case True{}:
      Spr.hud_tile(tx, votes, brains)
    case False{}:
      cell_frog(kind, tx, ty, px, py)

def cell_image(
  +kind: U32, +tx: U32, +ty: U32, +px: U32, +py: U32, +votes: U32,
  +brains: U32
) -> Image:
  cell_hud(kind, tx, ty, px, py, votes, brains, U32.is_eq(ty, 0))

def paint_got(
  +tx: U32, +ty: U32, +px: U32, +py: U32, +votes: U32, +brains: U32,
  map_id: U32, allies: U32, flags: U32, talk_npc: U32, talk_step: U32,
  cool: U32, left: Bool, right: Bool, up: Bool, down: Bool, mode: Mode,
  r: Array<U32> & U32
) -> Game & Image:
  (tiles, kind) = r
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    cell_image(kind, tx, ty, px, py, votes, brains)
  )

def paint_cell(g: Game, +tx: U32, +ty: U32) -> Game & Image:
  Game{tiles, map_id, +px, +py, +brains, +votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  paint_got(tx, ty, px, py, votes, brains, map_id, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, mode,
    Array.get(U32, tiles, (ty * 16 + tx : U32)))

def with_pair(
  r: Game & Image, k: Game -> Image -> Game & Image
) -> Game & Image:
  (g, img) = r
  k(g, img)

def pow2_local(+n: Nat) -> U32:
  match n:
    case 0n:
      1
    case 1n+p:
      (pow2_local(p) * 2 : U32)

def world(+d: Nat, g: Game, +tx: U32, +ty: U32) -> Game & Image:
  match d:
    case 0n:
      paint_cell(g, tx, ty)
    case 1n+p:
      +s = pow2_local(p)
      with_pair(world(p, g, tx, ty), g1 => tl => with_pair(world(p, g1,
        (tx + s : U32), ty), g2 => tr => with_pair(world(p, g2, tx,
        (ty + s : U32)), g3 => bl => with_pair(world(p, g3, (tx + s : U32),
        (ty + s : U32)), g4 => br => (g4, Qua{tl, tr, bl, br})))))

def look_talk(g: Game) -> Game & Image:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, +talk_npc,
    talk_step, cool, left, right, up, down, mode} = g
  (
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    Spr.talk_image(talk_npc)
  )

def look_mode(g: Game, mode: Mode) -> Game & Image:
  match mode:
    case Title{}:
      (g, Spr.title_image())
    case Play{}:
      world(4n, g, 0, 0)
    case Talk{}:
      look_talk(g)
    case Win{}:
      (g, Spr.win_image())

def look(g: Game) -> Game & Image:
  Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
    talk_step, cool, left, right, up, down, +mode} = g
  look_mode(
    Game{tiles, map_id, px, py, brains, votes, allies, flags, talk_npc,
      talk_step, cool, left, right, up, down, mode},
    mode
  )

def when_esc_pressed(
  g: Game, k: Game -> Maybe<Game>, pressed: Bool
) -> Maybe<Game>:
  match pressed:
    case True{}:
      None{}
    case False{}:
      k(g)

def when_esc_on(
  +code: U32, pressed: Bool, g: Game, k: Game -> Maybe<Game>, esc: Bool
) -> Maybe<Game>:
  match esc:
    case True{}:
      when_esc_pressed(g, k, pressed)
    case False{}:
      k(apply_key(code, pressed, g))

def when_esc(
  +code: U32, pressed: Bool, g: Game, k: Game -> Maybe<Game>
) -> Maybe<Game>:
  when_esc_on(code, pressed, g, k, key_is(code, 27, 65545))

def step(events: List<Event>, g: Game) -> Maybe<Game>:
  match events:
    case Nil{}:
      Some{frame(g)}
    case Con{Close{}, rest}:
      None{}
    case Con{Key{code, down}, rest}:
      when_esc(code, down, g, g2 => step(rest, g2))
    case Con{Mouse{x, y, button, down}, rest}:
      step(rest, g)
    case Con{Move{x, y}, rest}:
      step(rest, g)

def view(g: Game) -> Game & Image:
  look(g)

def tick(events: List<Event>, g: Game) -> IO(Maybe<Game>):
  IO.pure(Maybe<Game>, step(events, g))

def main() -> IO(Unit):
  App.run(~Game, ~App{view, tick},
    "Frog King — WASD move, Space talk", 256, 256, start())
