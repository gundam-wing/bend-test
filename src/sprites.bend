# Pixel-art sprites and tiles for Frog King.
# Colors are 0xRRGGBB stored as decimal U32 (Bend has no hex literals).
import Base

# Palette notes (hex in comments)
# TRANS  0xFF00FF  16711935
# HAT    0x6B3FA0   7028640
# STAR   0xF0D060  15781984
# GREEN  0x4CB050   5025872
# DKGR   0x2E7A36   3045942
# LTGR   0xA6F08A  10940554
# YEL    0xF2D04A  15913034
# WHITE  0xFFF8F0  16775408
# BLACK  0x1A1228   1708584
# CYAN   0x6EF0C8   7270600
# BROWN  0x8B5A2B   9132587
# PINK   0xFF7AA2  16743074
# GRASS1 0x3A8C40   3836992
# GRASS2 0x2F7A36   3111478
# GRASS3 0x4AA34A   4891466
# WATER1 0x2A6AA8   2779816
# WATER2 0x3A8BC4   3836868
# WATER3 0x1E4E82   1986178
# TREE   0x1F5A28   2054696
# TRUNK  0x6B3E1F   7028255
# WOOD   0x5A3A1E   5913118
# WOOD2  0x7A5028   8015912
# HUD    0x2A1A12   2759186
# GOLD   0xE8C547  15254855
# RED    0xC04040  12599360
# BAR_G  0x40C070   4243568
# SLOT   0x3A2818   3811352
# STEEL  0x6A7A88   6978184
# COG    0xC07030  12607536
# BLUE   0x4060C0   4227264
# ORANGE 0xE07020  14708768
# PURPLE 0x7040A0   7356576
# CROWN  0xFFD700  16766720

def TRANS() -> U32:
  16711935

def pow2(+n: Nat) -> U32:
  match n:
    case 0n:
      1
    case 1n+p:
      (pow2(p) * 2 : U32)

def grid(~pix: U32 -> U32 -> U32, +d: Nat, +x: U32, +y: U32) -> Image:
  match d:
    case 0n:
      Pix{pix(x, y)}
    case 1n+p:
      +s = pow2(p)
      tl tr = grid(~pix, p, x, y) grid(~pix, p, (x + s : U32), y)
      bl br = grid(~pix, p, x, (y + s : U32)) grid(~pix, p, (x + s : U32),
        (y + s : U32))
      Qua{tl, tr, bl, br}

def pal_p(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      16743074
    case False{}:
      1708080

def pal_r(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      9132587
    case False{}:
      pal_p(c, Char.is_eq(c, 'P'))

def pal_c(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      7270600
    case False{}:
      pal_r(c, Char.is_eq(c, 'R'))

def pal_b(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      1708584
    case False{}:
      pal_c(c, Char.is_eq(c, 'C'))

def pal_w(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      16775408
    case False{}:
      pal_b(c, Char.is_eq(c, 'B'))

def pal_y(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      15913034
    case False{}:
      pal_w(c, Char.is_eq(c, 'Y'))

def pal_l(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      10940554
    case False{}:
      pal_y(c, Char.is_eq(c, 'Y'))

def pal_k(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      3045942
    case False{}:
      pal_l(c, Char.is_eq(c, 'L'))

def pal_g(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      5025872
    case False{}:
      pal_k(c, Char.is_eq(c, 'K'))

def pal_s(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      15781984
    case False{}:
      pal_g(c, Char.is_eq(c, 'G'))

def pal_h(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      7028640
    case False{}:
      pal_s(c, Char.is_eq(c, 'S'))

def pal_o(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      14708768
    case False{}:
      pal_h(c, Char.is_eq(c, 'H'))

def pal_u(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      7356576
    case False{}:
      pal_o(c, Char.is_eq(c, 'O'))

def pal_e(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      6978184
    case False{}:
      pal_u(c, Char.is_eq(c, 'U'))

def pal_m(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      12607536
    case False{}:
      pal_e(c, Char.is_eq(c, 'E'))

def pal_n(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      4227264
    case False{}:
      pal_m(c, Char.is_eq(c, 'M'))

def pal_d(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      16766720
    case False{}:
      pal_n(c, Char.is_eq(c, 'N'))

def pal_dot(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      16711935
    case False{}:
      pal_d(c, Char.is_eq(c, 'D'))

def pal(+c: Char) -> U32:
  pal_dot(c, Char.is_eq(c, '.'))

def pal_maybe(c: Maybe<&2, Char>) -> U32:
  match c:
    case None{}:
      16711935
    case Some{ch}:
      pal(ch)

def art_pix(+art: String, x: U32, y: U32) -> U32:
  pal_maybe(String.get(art, U32.to_nat((y * 16 + x : U32))))

def art_grid(+d: Nat, +art: String, +x: U32, +y: U32) -> Image:
  match d:
    case 0n:
      Pix{art_pix(art, x, y)}
    case 1n+p:
      +s = pow2(p)
      tl tr = art_grid(p, art, x, y) art_grid(p, art, (x + s : U32), y)
      bl br = art_grid(p, art, x, (y + s : U32)) art_grid(p, art,
        (x + s : U32), (y + s : U32))
      Qua{tl, tr, bl, br}

def FROG_ART() -> String:
  "......H........." ++ ".....HHH........" ++ "....HHHHH......." ++
    "...HHHSHHH......" ++ "....HHHHH......." ++ ".....HHH...C...." ++
    "....LGGGL..C...." ++ "...LGWBWGL.R...." ++ "...KKGYYGK.R...." ++
    "....KGYYGK.R...." ++ ".....GYYG..R...." ++ ".....KGGK......." ++
    "....KK..KK......" ++ "....K....K......" ++ "...KK....KK....." ++
    "................"

def BRAIN_ART() -> String:
  "................" ++ ".....WWWWWW....." ++ "....WPPPPPPW...." ++
    "....WPPBBPPW...." ++ "....WPPPPPPW...." ++ ".....WWYYWW....." ++
    ".......YY......." ++ "....WW.GG.WW...." ++ ".....WWGGWW....." ++
    "......GGGG......" ++ ".....G.GG.G....." ++ "....G......G...." ++
    "................" ++ "................" ++ "................" ++
    "................"

def ELDER_ART() -> String:
  "......WWW......." ++ ".....WYYYW......" ++ "....WYYYYYW....." ++
    ".....WYYYW......" ++ "......GGG......." ++ ".....LGGGL......" ++
    "....LGWBWGL....." ++ "....KKGYYGK....." ++ ".....KGYYGK....." ++
    "......GYYG......" ++ ".....WWWWW......" ++ "....WYYYYYW....." ++
    "....WYYYYYW....." ++ ".....WWWWW......" ++ ".....K...K......" ++
    "....KK...KK....."

def ENGINEER_ART() -> String:
  ".....EEEEE......" ++ "....EMMMMME....." ++ "....EMWMWME....." ++
    ".....EMMME......" ++ "......GGG......." ++ ".....LGGGL......" ++
    "....LGWBWGL....." ++ "....KKGYYGK.M..." ++ ".....KGYYGK.M..." ++
    "......GYYG..M..." ++ ".....EEEEE......" ++ "....EMMMMME....." ++
    "....EM.M.ME....." ++ ".....EEEEE......" ++ ".....K...K......" ++
    "....KK...KK....."

def CAPTAIN_ART() -> String:
  "......NNN......." ++ ".....NWWWN......" ++ "....NWSWSWN....." ++
    ".....NWWWN......" ++ "......GGG......." ++ ".....LGGGL......" ++
    "....LGWBWGL....." ++ "....KKGYYGK....." ++ ".....KGYYGK.N..." ++
    "......GYYG.NN..." ++ ".....NNNNN......" ++ "....NYYYYYN....." ++
    "....NYNNNYN....." ++ ".....NNNNN......" ++ ".....K...K......" ++
    "....KK...KK....."

def MERCHANT_ART() -> String:
  "......OOO......." ++ ".....OYYYO......" ++ "....OYWBWYO....." ++
    ".....OYYYO......" ++ "......GGG......." ++ ".....LGGGL......" ++
    "....LGWBWGL....." ++ "....KKGYYGK.O..." ++ ".....KGYYGK.O..." ++
    "......GYYG..O..." ++ ".....OOOOO......" ++ "....OYYYYYO....." ++
    "....OYOOOYO....." ++ ".....OOOOO......" ++ ".....K...K......" ++
    "....KK...KK....."

def ORACLE_ART() -> String:
  "......UUU......." ++ ".....USUSU......" ++ "....UYYYYYU....." ++
    ".....UYYYU......" ++ "......GGG......." ++ ".....LGGGL......" ++
    "....LGWBWGL....." ++ "....KKGYYGK....." ++ ".....KGYYGK.U..." ++
    "......GYYG.UU..." ++ ".....UUUUU......" ++ "....UYYYYYU....." ++
    "....UYUYUYU....." ++ ".....UUUUU......" ++ ".....K...K......" ++
    "....KK...KK....."

def THRONE_ART() -> String:
  "......DDD......." ++ ".....DSDSD......" ++ "....DYYYYYD....." ++
    ".....DYYYD......" ++ "....YY...YY....." ++ "....Y.....Y....." ++
    "...YYWWWWWYY...." ++ "...YWYYYYYYW...." ++ "...YWYBBBYYW...." ++
    "...YWYYYYYYW...." ++ "...YYWWWWWYY...." ++ "....Y.....Y....." ++
    "....YY...YY....." ++ ".....YYYYY......" ++ "......YYY......." ++
    "................"

def WARP_ART() -> String:
  "................" ++ "......CCCC......" ++ ".....CYYYYC....." ++
    "....CYWBWYC....." ++ "....CYYYYYYC...." ++ ".....CYYYYC....." ++
    "......CCCC......" ++ ".......CC......." ++ "......CCCC......" ++
    ".....CYYYYC....." ++ "....CYWBWYC....." ++ "....CYYYYYYC...." ++
    ".....CYYYYC....." ++ "......CCCC......" ++ "................" ++
    "................"

def frog_sprite() -> Image:
  art_grid(4n, FROG_ART(), 0, 0)

def brain_sprite() -> Image:
  art_grid(4n, BRAIN_ART(), 0, 0)

def elder_sprite() -> Image:
  art_grid(4n, ELDER_ART(), 0, 0)

def engineer_sprite() -> Image:
  art_grid(4n, ENGINEER_ART(), 0, 0)

def captain_sprite() -> Image:
  art_grid(4n, CAPTAIN_ART(), 0, 0)

def merchant_sprite() -> Image:
  art_grid(4n, MERCHANT_ART(), 0, 0)

def oracle_sprite() -> Image:
  art_grid(4n, ORACLE_ART(), 0, 0)

def throne_sprite() -> Image:
  art_grid(4n, THRONE_ART(), 0, 0)

def warp_sprite() -> Image:
  art_grid(4n, WARP_ART(), 0, 0)

def overlay_two_pix(+key: U32, +c: U32, b: U32) -> Image:
  Bool.pick(Image, U32.is_eq(c, key), Pix{b}, Pix{c})

def overlay_drop0(+c: U32, u: Unit) -> Image:
  match u:
    case Unit{}:
      Pix{c}

def overlay_drop1(+c: U32, br: Image, u: Unit) -> Image:
  overlay_drop0(c, Image.sink(br))

def overlay_drop2(+c: U32, bl: Image, br: Image, u: Unit) -> Image:
  overlay_drop1(c, br, Image.sink(bl))

def overlay_drop3(+c: U32, tr: Image, bl: Image, br: Image, u: Unit) -> Image:
  overlay_drop2(c, bl, br, Image.sink(tr))

def overlay_drop4(+c: U32, tl: Image, tr: Image, bl: Image, br: Image) -> Image:
  overlay_drop3(c, tr, bl, br, Image.sink(tl))

def overlay_pix_qua_on(
  +c: U32, tl: Image, tr: Image, bl: Image, br: Image, trans: Bool
) -> Image:
  match trans:
    case True{}:
      Qua{tl, tr, bl, br}
    case False{}:
      overlay_drop4(c, tl, tr, bl, br)

def overlay_pix_qua(
  +key: U32, +c: U32, tl: Image, tr: Image, bl: Image, br: Image
) -> Image:
  overlay_pix_qua_on(c, tl, tr, bl, br, U32.is_eq(c, key))

def overlay(+key: U32, fg: Image, bg: Image) -> Image:
  match fg bg:
    case Pix{c} Pix{b}:
      overlay_two_pix(key, c, b)
    case Pix{c} Qua{tl, tr, bl, br}:
      overlay_pix_qua(key, c, tl, tr, bl, br)
    case Qua{tl, tr, bl, br} Pix{+c}:
      tl2 tr2 = overlay(key, tl, Pix{c}) overlay(key, tr, Pix{c})
      bl2 br2 = overlay(key, bl, Pix{c}) overlay(key, br, Pix{c})
      Qua{tl2, tr2, bl2, br2}
    case Qua{tl, tr, bl, br} Qua{btl, btr, bbl, bbr}:
      tl2 tr2 = overlay(key, tl, btl) overlay(key, tr, btr)
      bl2 br2 = overlay(key, bl, bbl) overlay(key, br, bbr)
      Qua{tl2, tr2, bl2, br2}

def grass_pix_eq2(x: U32, y: U32, z: Bool) -> U32:
  match z:
    case True{}:
      3111478
    case False{}:
      3836992

def grass_pix_eq1(+x: U32, +y: U32, +bits: U32, z: Bool) -> U32:
  match z:
    case True{}:
      3836992
    case False{}:
      grass_pix_eq2(x, y, U32.is_eq(bits, 2))

def grass_pix_eq(+x: U32, +y: U32, +bits: U32, z: Bool) -> U32:
  match z:
    case True{}:
      4891466
    case False{}:
      grass_pix_eq1(x, y, bits, U32.is_eq(bits, 1))

def grass_pix_on(+x: U32, +y: U32, +bits: U32) -> U32:
  grass_pix_eq(x, y, bits, U32.is_eq(bits, 0))

def grass_from(+x: U32, +y: U32) -> U32:
  grass_pix_on(x, y, U32.and((x + y : U32), 3))

def grass_pix(x: U32, y: U32) -> U32:
  grass_from(x, y)

def water_pix_eq2(x: U32, y: U32, z: Bool) -> U32:
  match z:
    case True{}:
      1986178
    case False{}:
      2779816

def water_pix_eq1(+x: U32, +y: U32, +bits: U32, z: Bool) -> U32:
  match z:
    case True{}:
      2779816
    case False{}:
      water_pix_eq2(x, y, U32.is_eq(bits, 2))

def water_pix_eq(+x: U32, +y: U32, +bits: U32, z: Bool) -> U32:
  match z:
    case True{}:
      3836868
    case False{}:
      water_pix_eq1(x, y, bits, U32.is_eq(bits, 1))

def water_pix_on(+x: U32, +y: U32, +bits: U32) -> U32:
  water_pix_eq(x, y, bits, U32.is_eq(bits, 0))

def water_from(+x: U32, +y: U32) -> U32:
  water_pix_on(x, y, U32.and((y + U32.shr(x) : U32), 3))

def water_pix(x: U32, y: U32) -> U32:
  water_from(x, y)

def tree_leaf(+x: U32, y: U32) -> U32:
  Bool.pick(U32, U32.is_eq(U32.and((x + y : U32), 1), 0), 2054696, 3045942)

def tree_canopy_on(+x: U32, +y: U32, wide: Bool) -> U32:
  match wide:
    case True{}:
      tree_leaf(x, y)
    case False{}:
      grass_pix(x, y)

def tree_canopy(+x: U32, +y: U32) -> U32:
  tree_canopy_on(x, y, Bool.and(U32.is_ge(x, 2), U32.is_le(x, 13)))

def tree_trunk(+x: U32, +y: U32, mid: Bool) -> U32:
  match mid:
    case True{}:
      7028255
    case False{}:
      grass_pix(x, y)

def tree_pix_on(+x: U32, +y: U32, trunk: Bool) -> U32:
  match trunk:
    case True{}:
      tree_trunk(x, y, Bool.and(U32.is_ge(x, 6), U32.is_le(x, 9)))
    case False{}:
      tree_canopy(x, y)

def tree_from(+x: U32, +y: U32) -> U32:
  tree_pix_on(x, y, U32.is_ge(y, 11))

def tree_pix(x: U32, y: U32) -> U32:
  tree_from(x, y)

def wood_pix_alt(x: U32, y: U32, knot: Bool) -> U32:
  match knot:
    case True{}:
      8015912
    case False{}:
      5913118

def wood_pix_on(+x: U32, +y: U32, grain: Bool) -> U32:
  match grain:
    case True{}:
      2759186
    case False{}:
      wood_pix_alt(x, y, U32.is_eq(U32.and(x, 7), 3))

def wood_from(+x: U32, +y: U32) -> U32:
  wood_pix_on(x, y, U32.is_eq(U32.and(y, 3), 0))

def wood_pix(x: U32, y: U32) -> U32:
  wood_from(x, y)

def floor_pix_alt(x: U32, y: U32, seam: Bool) -> U32:
  match seam:
    case True{}:
      6978184
    case False{}:
      3811352

def floor_from(+x: U32, +y: U32) -> U32:
  floor_pix_alt(x, y, U32.is_eq(U32.and((x + y : U32), 7), 0))

def floor_pix(x: U32, y: U32) -> U32:
  floor_from(x, y)

def grass_tile() -> Image:
  grid(~grass_pix, 4n, 0, 0)

def water_tile() -> Image:
  grid(~water_pix, 4n, 0, 0)

def tree_tile() -> Image:
  grid(~tree_pix, 4n, 0, 0)

def wood_tile() -> Image:
  grid(~wood_pix, 4n, 0, 0)

def floor_tile() -> Image:
  grid(~floor_pix, 4n, 0, 0)

def brain_tile() -> Image:
  overlay(16711935, brain_sprite(), grass_tile())

def elder_tile() -> Image:
  overlay(16711935, elder_sprite(), grass_tile())

def engineer_tile() -> Image:
  overlay(16711935, engineer_sprite(), floor_tile())

def captain_tile() -> Image:
  overlay(16711935, captain_sprite(), grass_tile())

def merchant_tile() -> Image:
  overlay(16711935, merchant_sprite(), grass_tile())

def oracle_tile() -> Image:
  overlay(16711935, oracle_sprite(), grass_tile())

def throne_tile() -> Image:
  overlay(16711935, throne_sprite(), floor_tile())

def warp_tile() -> Image:
  overlay(16711935, warp_sprite(), grass_tile())

def frog_on(bg: Image) -> Image:
  overlay(16711935, frog_sprite(), bg)

def tile_of_floor(kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      floor_tile()
    case False{}:
      grass_tile()

def tile_of_hud(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      wood_tile()
    case False{}:
      tile_of_floor(kind, U32.is_eq(kind, 12))

def tile_of_warp(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      warp_tile()
    case False{}:
      tile_of_hud(kind, U32.is_eq(kind, 9))

def tile_of_throne(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      throne_tile()
    case False{}:
      tile_of_warp(kind, U32.is_eq(kind, 11))

def tile_of_oracle(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      oracle_tile()
    case False{}:
      tile_of_throne(kind, U32.is_eq(kind, 10))

def tile_of_merchant(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      merchant_tile()
    case False{}:
      tile_of_oracle(kind, U32.is_eq(kind, 8))

def tile_of_captain(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      captain_tile()
    case False{}:
      tile_of_merchant(kind, U32.is_eq(kind, 7))

def tile_of_engineer(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      engineer_tile()
    case False{}:
      tile_of_captain(kind, U32.is_eq(kind, 6))

def tile_of_elder(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      elder_tile()
    case False{}:
      tile_of_engineer(kind, U32.is_eq(kind, 5))

def tile_of_tree(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      tree_tile()
    case False{}:
      tile_of_elder(kind, U32.is_eq(kind, 4))

def tile_of_water(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      water_tile()
    case False{}:
      tile_of_tree(kind, U32.is_eq(kind, 3))

def tile_of_brain(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      brain_tile()
    case False{}:
      tile_of_water(kind, U32.is_eq(kind, 1))

def tile_of(+kind: U32) -> Image:
  tile_of_brain(kind, U32.is_eq(kind, 2))

def npc_art(+npc: U32) -> String:
  Bool.pick(String, U32.is_eq(npc, 1), ELDER_ART(),
    Bool.pick(String, U32.is_eq(npc, 2), ENGINEER_ART(),
      Bool.pick(String, U32.is_eq(npc, 3), CAPTAIN_ART(),
        Bool.pick(String, U32.is_eq(npc, 4), MERCHANT_ART(),
          Bool.pick(String, U32.is_eq(npc, 5), ORACLE_ART(),
            Bool.pick(String, U32.is_eq(npc, 6), THRONE_ART(),
              FROG_ART()))))))

def slot_empty_y(+x: U32, +y: U32, inner: Bool) -> U32:
  match inner:
    case True{}:
      3811352
    case False{}:
      wood_pix(x, y)

def slot_empty_on(+x: U32, +y: U32, wide: Bool) -> U32:
  match wide:
    case True{}:
      slot_empty_y(x, y, Bool.and(U32.is_ge(y, 3), U32.is_le(y, 12)))
    case False{}:
      wood_pix(x, y)

def slot_from(+x: U32, +y: U32) -> U32:
  slot_empty_on(x, y, Bool.and(U32.is_ge(x, 3), U32.is_le(x, 12)))

def slot_empty_pix(x: U32, y: U32) -> U32:
  slot_from(x, y)

def slot_tile(+filled: Bool) -> Image:
  match filled:
    case True{}:
      overlay(16711935, frog_sprite(), wood_tile())
    case False{}:
      grid(~slot_empty_pix, 4n, 0, 0)

def brain_hud_tile(+filled: Bool) -> Image:
  match filled:
    case True{}:
      overlay(16711935, brain_sprite(), wood_tile())
    case False{}:
      grid(~slot_empty_pix, 4n, 0, 0)

# HUD: tx 1-5 = council votes, tx 7-9 = brains held, rest wood.
def hud_tile_brain(+tx: U32, +brains: U32, brain_slot: Bool) -> Image:
  match brain_slot:
    case True{}:
      brain_hud_tile(U32.is_ge(brains, (tx - 6 : U32)))
    case False{}:
      wood_tile()

def hud_tile_vote(+tx: U32, +votes: U32, +brains: U32, vote: Bool) -> Image:
  match vote:
    case True{}:
      slot_tile(U32.is_ge(votes, tx))
    case False{}:
      hud_tile_brain(tx, brains, Bool.and(U32.is_ge(tx, 7), U32.is_le(tx, 9)))

def hud_tile(+tx: U32, +votes: U32, +brains: U32) -> Image:
  hud_tile_vote(tx, votes, brains, Bool.and(U32.is_ge(tx, 1), U32.is_le(tx, 5)))

def win_bg(+x: U32, +y: U32) -> U32:
  Bool.pick(U32, U32.is_eq(U32.and((x + U32.shrn(y, 2n) : U32), 15), 0),
    15254855, 1318936)

def win_pix_y(+x: U32, +y: U32, tall: Bool) -> U32:
  match tall:
    case True{}:
      art_pix(FROG_ART(), U32.div((x - 96 : U32), 4), U32.div((y - 96 : U32), 4))
    case False{}:
      win_bg(x, y)

def win_pix_box(+x: U32, +y: U32, wide: Bool) -> U32:
  match wide:
    case True{}:
      win_pix_y(x, y, Bool.and(U32.is_ge(y, 96), U32.is_lt(y, 160)))
    case False{}:
      win_bg(x, y)

def win_crown(+x: U32, +y: U32, crown: Bool) -> U32:
  match crown:
    case True{}:
      art_pix(THRONE_ART(), U32.div((x - 96 : U32), 4),
        U32.div((y - 32 : U32), 4))
    case False{}:
      win_pix_box(x, y, Bool.and(U32.is_ge(x, 96), U32.is_lt(x, 160)))

def win_from(+x: U32, +y: U32) -> U32:
  win_crown(x, y, Bool.and(Bool.and(U32.is_ge(x, 96), U32.is_lt(x, 160)),
    Bool.and(U32.is_ge(y, 32), U32.is_lt(y, 96))))

def win_pix(x: U32, y: U32) -> U32:
  win_from(x, y)

def title_bg(+x: U32, +y: U32) -> U32:
  Bool.pick(U32, U32.is_eq(U32.and((x + y : U32), 31), 0), 7270600, 1708080)

def title_pix_y(+x: U32, +y: U32, tall: Bool) -> U32:
  match tall:
    case True{}:
      art_pix(FROG_ART(), U32.div((x - 96 : U32), 4), U32.div((y - 80 : U32), 4))
    case False{}:
      title_bg(x, y)

def title_from(+x: U32, +y: U32) -> U32:
  title_pix_y(x, y, Bool.and(Bool.and(U32.is_ge(x, 96), U32.is_lt(x, 160)),
    Bool.and(U32.is_ge(y, 80), U32.is_lt(y, 144))))

def title_pix(x: U32, y: U32) -> U32:
  title_from(x, y)

def talk_bg(+x: U32, +y: U32) -> U32:
  Bool.pick(U32, U32.is_lt(y, 48), 2759186, 1708584)

def talk_pix_npc(+npc: U32, +x: U32, +y: U32, face: Bool) -> U32:
  match face:
    case True{}:
      art_pix(npc_art(npc), U32.div((x - 16 : U32), 4),
        U32.div((y - 64 : U32), 4))
    case False{}:
      talk_bg(x, y)

def talk_from(+npc: U32, +x: U32, +y: U32) -> U32:
  talk_pix_npc(npc, x, y, Bool.and(Bool.and(U32.is_ge(x, 16), U32.is_lt(x, 80)),
    Bool.and(U32.is_ge(y, 64), U32.is_lt(y, 128))))

def talk_pix_n(+npc: U32, x: U32, y: U32) -> U32:
  talk_from(npc, x, y)

def talk_grid(+d: Nat, +npc: U32, +x: U32, +y: U32) -> Image:
  match d:
    case 0n:
      Pix{talk_pix_n(npc, x, y)}
    case 1n+p:
      +s = pow2(p)
      tl tr = talk_grid(p, npc, x, y) talk_grid(p, npc, (x + s : U32), y)
      bl br = talk_grid(p, npc, x, (y + s : U32)) talk_grid(p, npc,
        (x + s : U32), (y + s : U32))
      Qua{tl, tr, bl, br}

def win_image() -> Image:
  grid(~win_pix, 8n, 0, 0)

def title_image() -> Image:
  grid(~title_pix, 8n, 0, 0)

def talk_image(+npc: U32) -> Image:
  talk_grid(8n, npc, 0, 0)
