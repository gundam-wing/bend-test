# Proven Goose Pond -- the Bend half.
#
# A torus pond, a walled nesting room, a Golden Goose (F), and four paddles.
# Stepping onto the goose's cell would be a win -- and LAWS.bend proves that
# no sequence of moves can ever do that. The host (host/play.mjs) asks Jev to
# pick each move from the player's vibes; Bend enforces reality.
#
# Geometry and step logic match the classic "Winning Is Impossible" demo so
# the certificate in PROOF.bend stays honest. Flavor is ours.

import Base

type Move is Data:
  Up{}
  Down{}
  Left{}
  Right{}

type Game is Data:
  Game{x: Nat, y: Nat, won: Bool}

# Pond
# ----

def map_w() -> Nat:
  12n

def map_h() -> Nat:
  8n

def room_w() -> Nat:
  3n

def room_h() -> Nat:
  3n

def flag_x() -> Nat:
  1n

def flag_y() -> Nat:
  1n

def start_x() -> Nat:
  8n

def start_y() -> Nat:
  5n

def nat_eq(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          True{}
        case 1n+q:
          False{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          nat_eq(p, q)

def nat_le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          nat_le(p, q)

def wall(+x: Nat, +y: Nat) -> Bool:
  east  = nat_eq(x, room_w()) && nat_le(y, room_h())
  south = nat_le(x, room_w()) && nat_eq(y, room_h())
  north = nat_le(x, room_w()) && nat_eq(y, Nat.sub(map_h(), 1n))
  west  = nat_eq(x, Nat.sub(map_w(), 1n)) && nat_le(y, room_h())
  (east || south) || (north || west)

# Step
# ----

def pick(-A: Type, c: Bool, a: A, b: A) -> A:
  match c:
    case True{}:
      a
    case False{}:
      b

def warp_up(y: Nat) -> Nat:
  match y:
    case 0n:
      Nat.sub(map_h(), 1n)
    case 1n+p:
      p

def warp_down(+y: Nat) -> Nat:
  pick(Nat, nat_eq(1n+y, map_h()), 0n, 1n+y)

def warp_left(x: Nat) -> Nat:
  match x:
    case 0n:
      Nat.sub(map_w(), 1n)
    case 1n+p:
      p

def warp_right(+x: Nat) -> Nat:
  pick(Nat, nat_eq(1n+x, map_w()), 0n, 1n+x)

def on_flag(+x: Nat, +y: Nat) -> Bool:
  nat_eq(x, flag_x()) && nat_eq(y, flag_y())

def move(+tx: Nat, +ty: Nat, g: Game) -> Game:
  Game{x, y, +w0} = g
  pick(Game, wall(tx, ty), Game{x, y, w0}, Game{tx, ty, w0 || on_flag(tx, ty)})

def step(a: Move, g: Game) -> Game:
  match a:
    case Up{}:
      Game{+x0, +y0, w} = g
      move(x0, warp_up(y0), Game{x0, y0, w})
    case Down{}:
      Game{+x0, +y0, w} = g
      move(x0, warp_down(y0), Game{x0, y0, w})
    case Left{}:
      Game{+x0, +y0, w} = g
      move(warp_left(x0), y0, Game{x0, y0, w})
    case Right{}:
      Game{+x0, +y0, w} = g
      move(warp_right(x0), y0, Game{x0, y0, w})

def start() -> Game:
  Game{start_x(), start_y(), False{}}

def key(+k: U32) -> Maybe<Move>:
  pick(Maybe<Move>, U32.is_eq(k, 119), Some{Up{}},
    pick(Maybe<Move>, U32.is_eq(k, 115), Some{Down{}},
      pick(Maybe<Move>, U32.is_eq(k, 97), Some{Left{}},
        pick(Maybe<Move>, U32.is_eq(k, 100), Some{Right{}}, None{}))))

def run(moves: List<Move>, g: Game) -> Game:
  match moves:
    case Nil{}:
      g
    case m <> ms:
      run(ms, step(m, g))

def replay(g: Game, moves: List<Move>) -> Game:
  run(moves, g)

def is_won(g: Game) -> Bool:
  Game{x, y, w} = g
  w

# Show
# ----
# '#' nest wall, 'F' Golden Goose, 'P' duck start, '.' open water.

def cell(+x: Nat, +y: Nat) -> String:
  is_flag  = on_flag(x, y)
  is_start = nat_eq(x, start_x()) && nat_eq(y, start_y())
  pick(String, wall(x, y), "#",
    pick(String, is_flag, "F",
      pick(String, is_start, "P", ".")))

def row(x: Nat, +y: Nat) -> String:
  match x:
    case 0n:
      cell(0n, y)
    case 1n++p0:
      row(p0, y) ++ cell(1n+p0, y)

def grid(y: Nat) -> String:
  match y:
    case 0n:
      row(Nat.sub(map_w(), 1n), 0n)
    case 1n++p0:
      grid(p0) ++ "\n" ++ row(Nat.sub(map_w(), 1n), 1n+p0)

# Parallel theorem pulse: count open-water cells by splitting the pond in half.
# Host shows this as "Bend is still enumerating reality in parallel".

def open_at(+x: Nat, +y: Nat) -> U32:
  pick(U32, wall(x, y), 0, pick(U32, on_flag(x, y), 0, 1))

def count_row(x: Nat, +y: Nat) -> U32:
  match x:
    case 0n:
      open_at(0n, y)
    case 1n++p0:
      a b = count_row(p0, y) open_at(1n+p0, y)
      (a + b : U32)

def count_open(y: Nat) -> U32:
  match y:
    case 0n:
      count_row(Nat.sub(map_w(), 1n), 0n)
    case 1n++p0:
      a b = count_open(p0) count_row(Nat.sub(map_w(), 1n), 1n+p0)
      (a + b : U32)

def open_water() -> U32:
  count_open(Nat.sub(map_h(), 1n))

def main() -> IO(Unit):
  do IO<Unit>:
    u : Unit <- IO.print(grid(Nat.sub(map_h(), 1n)))
    open : U32 = open_water()
    IO.print("open water cells (parallel count): " ++ U32.show(open))
