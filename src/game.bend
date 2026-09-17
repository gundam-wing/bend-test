# Frog Wizard: collect 12 fly brains in 2 minutes.
import Base
import ./sprites.bend as Spr

type Mode is Data:
  Play{}
  Win{}
  Lose{}

type Dir is Data:
  Stay{}
  Left{}
  Right{}
  Up{}
  Down{}

type Game is Type:
  Game{
    tiles: Array<U32>,
    px: U32,
    py: U32,
    score: U32,
    time: U32,
    cool: U32,
    left: Bool,
    right: Bool,
    up: Bool,
    down: Bool,
    mode: Mode
  }

def GOAL() -> U32:
  12

def TIME_LIMIT() -> U32:
  7200

def STEP_COOL() -> U32:
  8

def MAP_W() -> U32:
  16

def walkable(+kind: U32) -> Bool:
  Bool.or(U32.is_eq(kind, 0), U32.is_eq(kind, 2))

def paint(xs: List<&2, U32>, a: Array<U32>, +v: U32) -> Array<U32>:
  match xs:
    case Nil{}:
      a
    case Con{i, t}:
      paint(t, Array.set(U32, a, i, v), v)

# 16x16 swamp. Row 0 and the border are wooden walls (9), water is 1,
# trees are 3, fly brains are 2, grass is 0. Frog starts at (2, 1).
def HUD_CELLS() -> List<&2, U32>:
  [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 31, 32, 47,
    48, 63, 64, 79, 80, 95, 96, 111, 112, 127, 128, 143, 144, 159, 160, 175,
    176, 191, 192, 207, 208, 223, 224, 239, 240, 241, 242, 243, 244, 245,
    246, 247, 248, 249, 250, 251, 252, 253, 254, 255
  ]

def WATER_CELLS() -> List<&2, U32>:
  [
    34, 35, 36, 43, 44, 45, 50, 51, 52, 59, 60, 61, 162, 163, 164, 171, 172,
    173, 178, 179, 180, 187, 188, 189
  ]

def TREE_CELLS() -> List<&2, U32>:
  [87, 88, 89, 90, 103, 106, 119, 121, 135, 136, 137, 138]

def BRAIN_CELLS() -> List<&2, U32>:
  [29, 55, 83, 93, 114, 120, 141, 183, 195, 218, 226, 237]

def start_tiles() -> Array<U32>:
  paint(BRAIN_CELLS(), paint(TREE_CELLS(), paint(WATER_CELLS(),
    paint(HUD_CELLS(), [0 : U32^8n], 9), 1), 3), 2)

def start() -> Game:
  Game{
    start_tiles(), 2, 1, 0, TIME_LIMIT(), 0, False{}, False{}, False{},
    False{}, Play{}
  }

def count_leaf_on(acc: U32, z: Bool) -> U32:
  match z:
    case True{}:
      (acc + 1 : U32)
    case False{}:
      acc

def count_leaf(+k: U32, x: U32, acc: U32) -> U32:
  count_leaf_on(acc, U32.is_eq(x, k))

def count_go(a: Array<U32>, +k: U32, acc: U32) -> U32:
  match a:
    case ALeaf{x}:
      count_leaf(k, x, acc)
    case ANode{xs, ys}:
      count_go(ys, k, count_go(xs, k, acc))

def count_kind(a: Array<U32>, +k: U32) -> U32:
  count_go(a, k, 0)

def brain_count() -> U32:
  count_kind(start_tiles(), 2)

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

def win_check_on(
  tiles: Array<U32>, +px: U32, +py: U32, +score: U32, time: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, won: Bool
) -> Game:
  match won:
    case True{}:
      Game{tiles, px, py, score, time, STEP_COOL(), left, right, up, down, Win{}}
    case False{}:
      Game{tiles, px, py, score, time, STEP_COOL(), left, right, up, down, Play{}}

def win_check(
  tiles: Array<U32>, +px: U32, +py: U32, +score: U32, time: U32, left: Bool,
  right: Bool, up: Bool, down: Bool
) -> Game:
  win_check_on(tiles, px, py, score, time, left, right, up, down,
    U32.is_ge(score, GOAL()))

def pickup_on(
  tiles: Array<U32>, +nx: U32, +ny: U32, +score: U32, time: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, +kind: U32, brain: Bool
) -> Game:
  match brain:
    case True{}:
      win_check(Array.set(U32, tiles, (ny * 16 + nx : U32), 0), nx, ny,
        (score + 1 : U32), time, left, right, up, down)
    case False{}:
      Game{tiles, nx, ny, score, time, STEP_COOL(), left, right, up, down, Play{}}

def pickup(
  tiles: Array<U32>, +nx: U32, +ny: U32, +score: U32, time: U32, left: Bool,
  right: Bool, up: Bool, down: Bool, +kind: U32
) -> Game:
  pickup_on(tiles, nx, ny, score, time, left, right, up, down, kind,
    U32.is_eq(kind, 2))

def nudge_kind(
  tiles: Array<U32>, +nx: U32, +ny: U32, px: U32, py: U32, score: U32,
  time: U32, cool: U32, left: Bool, right: Bool, up: Bool, down: Bool,
  mode: Mode, +kind: U32, ok: Bool
) -> Game:
  match ok:
    case True{}:
      pickup(tiles, nx, ny, score, time, left, right, up, down, kind)
    case False{}:
      Game{tiles, px, py, score, time, cool, left, right, up, down, mode}

def nudge_got(
  +nx: U32, +ny: U32, px: U32, py: U32, score: U32, time: U32, cool: U32,
  left: Bool, right: Bool, up: Bool, down: Bool, mode: Mode,
  r: Array<U32> & U32
) -> Game:
  (tiles, +kind) = r
  nudge_kind(tiles, nx, ny, px, py, score, time, cool, left, right, up, down,
    mode, kind, walkable(kind))

def nudge(g: Game, +nx: U32, +ny: U32) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  nudge_got(nx, ny, px, py, score, time, cool, left, right, up, down, mode,
    Array.get(U32, tiles, (ny * 16 + nx : U32)))

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
  Game{tiles, +px, +py, score, time, cool, left, right, up, down, mode} = g
  try_move_dir(Game{tiles, px, py, score, time, cool, left, right, up, down,
    mode}, px, py, dir)

def set_cool(g: Game, cool2: U32) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool2, left, right, up, down, mode}

def set_time(g: Game, time2: U32) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time2, cool, left, right, up, down, mode}

def to_lose(g: Game) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool, left, right, up, down, Lose{}}

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

def frame_move(g: Game) -> Game:
  Game{tiles, px, py, score, time, +cool, +left, +right, +up, +down, mode} = g
  frame_cool(Game{tiles, px, py, score, time, cool, left, right, up, down,
    mode}, cool, left, right, up, down)

def frame_clock_on(g: Game, +time: U32, dead: Bool) -> Game:
  match dead:
    case True{}:
      to_lose(g)
    case False{}:
      frame_move(set_time(g, (time - 1 : U32)))

def frame_clock(g: Game, +time: U32) -> Game:
  frame_clock_on(g, time, U32.is_eq(time, 0))

def frame_play(g: Game) -> Game:
  Game{tiles, px, py, score, +time, cool, left, right, up, down, mode} = g
  frame_clock(Game{tiles, px, py, score, time, cool, left, right, up, down,
    mode}, time)

def frame_mode(g: Game, mode: Mode) -> Game:
  match mode:
    case Play{}:
      frame_play(g)
    case Win{}:
      g
    case Lose{}:
      g

def frame(g: Game) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, +mode} = g
  frame_mode(Game{tiles, px, py, score, time, cool, left, right, up, down,
    mode}, mode)

def set_left(g: Game, pressed: Bool) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool, pressed, right, up, down, mode}

def set_right(g: Game, pressed: Bool) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool, left, pressed, up, down, mode}

def set_up(g: Game, pressed: Bool) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool, left, right, pressed, down, mode}

def set_down(g: Game, pressed: Bool) -> Game:
  Game{tiles, px, py, score, time, cool, left, right, up, down, mode} = g
  Game{tiles, px, py, score, time, cool, left, right, up, pressed, mode}

def apply_arrow_d(code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_down(g, pressed)
    case False{}:
      g

def apply_arrow_u(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_up(g, pressed)
    case False{}:
      apply_arrow_d(code, pressed, g, U32.is_eq(code, 63233))

def apply_arrow_r(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_right(g, pressed)
    case False{}:
      apply_arrow_u(code, pressed, g, U32.is_eq(code, 63232))

def apply_arrow_l(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_left(g, pressed)
    case False{}:
      apply_arrow_r(code, pressed, g, U32.is_eq(code, 63235))

def apply_downk(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_down(g, pressed)
    case False{}:
      apply_arrow_l(code, pressed, g, U32.is_eq(code, 63234))

def apply_up(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_up(g, pressed)
    case False{}:
      apply_downk(code, pressed, g, U32.is_eq(code, 115))

def apply_right(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_right(g, pressed)
    case False{}:
      apply_up(code, pressed, g, U32.is_eq(code, 119))

def apply_left(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      set_left(g, pressed)
    case False{}:
      apply_right(code, pressed, g, U32.is_eq(code, 100))

def apply_restart(pressed: Bool, g: Game) -> Game:
  match pressed:
    case True{}:
      start()
    case False{}:
      g

def apply_r(+code: U32, pressed: Bool, g: Game, z: Bool) -> Game:
  match z:
    case True{}:
      apply_restart(pressed, g)
    case False{}:
      apply_left(code, pressed, g, U32.is_eq(code, 97))

def apply_key(+code: U32, pressed: Bool, g: Game) -> Game:
  apply_r(code, pressed, g, U32.is_eq(code, 114))

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
  +kind: U32, +tx: U32, +ty: U32, +px: U32, +py: U32, +score: U32, +time: U32,
  hud: Bool
) -> Image:
  match hud:
    case True{}:
      Spr.hud_tile(tx, score, time)
    case False{}:
      cell_frog(kind, tx, ty, px, py)

def cell_image(
  +kind: U32, +tx: U32, +ty: U32, +px: U32, +py: U32, +score: U32, +time: U32
) -> Image:
  cell_hud(kind, tx, ty, px, py, score, time, U32.is_eq(ty, 0))

def paint_got(
  +tx: U32, +ty: U32, +px: U32, +py: U32, +score: U32, +time: U32, cool: U32,
  left: Bool, right: Bool, up: Bool, down: Bool, mode: Mode, r: Array<U32> & U32
) -> Game & Image:
  (tiles, kind) = r
  (
    Game{tiles, px, py, score, time, cool, left, right, up, down, mode},
    cell_image(kind, tx, ty, px, py, score, time)
  )

def paint_cell(g: Game, +tx: U32, +ty: U32) -> Game & Image:
  Game{tiles, +px, +py, +score, +time, cool, left, right, up, down, mode} = g
  paint_got(tx, ty, px, py, score, time, cool, left, right, up, down, mode,
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

def look_mode(g: Game, mode: Mode) -> Game & Image:
  match mode:
    case Play{}:
      world(4n, g, 0, 0)
    case Win{}:
      (g, Spr.win_image())
    case Lose{}:
      (g, Spr.lose_image())

def look(g: Game) -> Game & Image:
  Game{tiles, px, py, score, time, cool, left, right, up, down, +mode} = g
  look_mode(Game{tiles, px, py, score, time, cool, left, right, up, down, mode},
    mode)

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
  when_esc_on(code, pressed, g, k, U32.is_eq(code, 27))

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
  App.run(~Game, ~App{view, tick}, "Frog Wizard", 256, 256, start())
