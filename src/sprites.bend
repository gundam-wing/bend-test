# Pixel-art sprites and tiles for Frog Wizard.
# Colors are 0xRRGGBB stored as decimal U32 (Bend has no hex literals).
import Base

# Palette (hex in comments)
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
# BAR_Y  0xD0B040  13676608
# WINBG  0x142018   1318936
# LOSEBG 0x280808   2623496
# SKY    0x1A1030   1708080
# SLOT   0x3A2818   3811352

def TRANS() -> U32:
  16711935

def pow2(+n: Nat) -> U32:
  match n:
    case 0n:
      1
    case 1n+p:
      (pow2(p) * 2 : U32)

def toss(u: Unit) -> U32:
  match u:
    case Unit{}:
      0

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
      pal_w(c, Char.is_eq(c, 'W'))

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

def pal_dot(+c: Char, z: Bool) -> U32:
  match z:
    case True{}:
      16711935
    case False{}:
      pal_h(c, Char.is_eq(c, 'H'))

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

def frog_sprite() -> Image:
  art_grid(4n, FROG_ART(), 0, 0)

def brain_sprite() -> Image:
  art_grid(4n, BRAIN_ART(), 0, 0)

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

def grass_tile() -> Image:
  grid(~grass_pix, 4n, 0, 0)

def water_tile() -> Image:
  grid(~water_pix, 4n, 0, 0)

def tree_tile() -> Image:
  grid(~tree_pix, 4n, 0, 0)

def wood_tile() -> Image:
  grid(~wood_pix, 4n, 0, 0)

def brain_tile() -> Image:
  overlay(16711935, brain_sprite(), grass_tile())

def frog_on(bg: Image) -> Image:
  overlay(16711935, frog_sprite(), bg)

def tile_of_hud(kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      wood_tile()
    case False{}:
      grass_tile()

def tile_of_tree(+kind: U32, z: Bool) -> Image:
  match z:
    case True{}:
      tree_tile()
    case False{}:
      tile_of_hud(kind, U32.is_eq(kind, 9))

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
      overlay(16711935, brain_sprite(), wood_tile())
    case False{}:
      grid(~slot_empty_pix, 4n, 0, 0)

def bar_fill(+time: U32) -> U32:
  U32.div(time, 150)

def bar_color_mid(time: U32, mid: Bool) -> U32:
  match mid:
    case True{}:
      13676608
    case False{}:
      4243568

def bar_color_low(+time: U32, low: Bool) -> U32:
  match low:
    case True{}:
      12599360
    case False{}:
      bar_color_mid(time, U32.is_lt(time, 3600))

def bar_color(+time: U32) -> U32:
  bar_color_low(time, U32.is_lt(time, 1800))

def bar_pix_on(+time: U32, +x: U32, +y: U32, filled: Bool) -> U32:
  match filled:
    case True{}:
      bar_color(time)
    case False{}:
      3811352

def bar_pix_fill(+time: U32, +tx: U32, +x: U32, +y: U32) -> U32:
  +col = ((tx - 13 : U32) * 16 + x : U32)
  bar_pix_on(time, x, y, U32.is_lt(col, bar_fill(time)))

def bar_pix_y(+time: U32, +tx: U32, +x: U32, +y: U32, band: Bool) -> U32:
  match band:
    case True{}:
      bar_pix_fill(time, tx, x, y)
    case False{}:
      wood_pix(x, y)

def bar_pix(+time: U32, +tx: U32, +x: U32, +y: U32) -> U32:
  bar_pix_y(time, tx, x, y, Bool.and(U32.is_ge(y, 4), U32.is_le(y, 11)))

def bar_grid(+d: Nat, +time: U32, +tx: U32, +x: U32, +y: U32) -> Image:
  match d:
    case 0n:
      Pix{bar_pix(time, tx, x, y)}
    case 1n+p:
      +s = pow2(p)
      tl tr = bar_grid(p, time, tx, x, y) bar_grid(p, time, tx, (x + s : U32), y)
      bl br = bar_grid(p, time, tx, x, (y + s : U32)) bar_grid(p, time, tx,
        (x + s : U32), (y + s : U32))
      Qua{tl, tr, bl, br}

def hud_tile_bar(+tx: U32, +time: U32, bar: Bool) -> Image:
  match bar:
    case True{}:
      bar_grid(4n, time, tx, 0, 0)
    case False{}:
      wood_tile()

def hud_tile_slot(+tx: U32, +score: U32, +time: U32, slot: Bool) -> Image:
  match slot:
    case True{}:
      slot_tile(U32.is_ge(score, tx))
    case False{}:
      hud_tile_bar(tx, time, U32.is_ge(tx, 13))

def hud_tile(+tx: U32, +score: U32, +time: U32) -> Image:
  hud_tile_slot(tx, score, time, Bool.and(U32.is_ge(tx, 1), U32.is_le(tx, 12)))

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

def win_from(+x: U32, +y: U32) -> U32:
  win_pix_box(x, y, Bool.and(U32.is_ge(x, 96), U32.is_lt(x, 160)))

def win_pix(x: U32, y: U32) -> U32:
  win_from(x, y)

def lose_bg(+x: U32, +y: U32) -> U32:
  Bool.pick(U32, U32.is_eq(U32.and((x + y : U32), 7), 0), 12599360, 2623496)

def lose_pix_y(+x: U32, +y: U32, tall: Bool) -> U32:
  match tall:
    case True{}:
      art_pix(BRAIN_ART(), U32.div((x - 96 : U32), 4),
        U32.div((y - 96 : U32), 4))
    case False{}:
      lose_bg(x, y)

def lose_pix_box(+x: U32, +y: U32, wide: Bool) -> U32:
  match wide:
    case True{}:
      lose_pix_y(x, y, Bool.and(U32.is_ge(y, 96), U32.is_lt(y, 160)))
    case False{}:
      lose_bg(x, y)

def lose_from(+x: U32, +y: U32) -> U32:
  lose_pix_box(x, y, Bool.and(U32.is_ge(x, 96), U32.is_lt(x, 160)))

def lose_pix(x: U32, y: U32) -> U32:
  lose_from(x, y)

def win_image() -> Image:
  grid(~win_pix, 8n, 0, 0)

def lose_image() -> Image:
  grid(~lose_pix, 8n, 0, 0)
