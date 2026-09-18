# Proven Goose Pond -- the laws (humans write these; AIs may not weaken them).
#
# Claim: no paddle sequence ever catches the Golden Goose. The host may let
# Jev invent vibes all day; Bend still refuses to make winning possible.

import Base
import ./main.bend as Game

# LAW: for any sequence of moves, replaying them
# from the start can never lead to victory.
law you_cant_win:
  for moves: List<Game.Move>
  board = Game.replay(Game.start(), moves)
  {Game.is_won(board) == False{} : Bool}

# The board the host draws: grid(map_h() - 1), one row per line, and
# the reading of it: the character at column x of row y, 'F'
# where it draws the Golden Goose. Both laws bind exactly what is shown.
def drawn() -> String:
  Game.grid(Nat.sub(Game.map_h(), 1n))

def ch(c: Char, k: U32) -> Bool:
  Chr{code} = c
  U32.is_eq(code, k)

def pick(-A: Type, c: Bool, a: A, b: A) -> A:
  match c:
    case True{}:
      a
    case False{}:
      b

def next_row(s: String) -> String:
  match s:
    case SNil{}:
      SNil{}
    case SCon{c, +rest}:
      pick(String, ch(c, 10), rest, next_row(rest))

def flag_in_row(s: String, x: Nat) -> Bool:
  match s:
    case SNil{}:
      False{}
    case SCon{c, rest}:
      match x:
        case 0n:
          ch(c, 70)
        case 1n+p:
          pick(Bool, ch(c, 10), False{}, flag_in_row(rest, p))

def flag_at(y: Nat, x: Nat, s: String) -> Bool:
  match y:
    case 0n:
      flag_in_row(s, x)
    case 1n+q:
      flag_at(q, x, next_row(s))

def at_flag(g: Game.Game) -> Bool:
  Game.Game{x, y, won} = g
  flag_at(y, x, drawn())

# LAW: the duck never stands on the goose: no sequence of moves puts
# the player on an 'F' cell of the drawn pond.
law never_on_flag:
  for moves: List<Game.Move>
  board = Game.replay(Game.start(), moves)
  {at_flag(board) == False{} : Bool}
