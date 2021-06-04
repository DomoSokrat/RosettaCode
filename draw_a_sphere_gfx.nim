# Ubuntu: --no-install-recommends libgl1-mesa-dev libxcursor-dev libxrandr-dev libxi-dev libxinerama-dev
# Alpine: mesa-dev libxcursor-dev libxrandr-dev libxi-dev libxinerama-dev
import math
import rapid/gfx

type
  Point = tuple[x, y, z: float]

func dot(a, b: Point): float =
  max(a.x*b.x + a.y*b.y + a.z*b.z, 0)
  #a.x*b.x + a.y*b.y + a.z*b.z

func normalize(v: Point): Point =
  let length = v.dot(v).sqrt
  result.x = v.x / length
  result.y = v.y / length
  result.z = v.z / length

func `*`(c: RColor; intensity: float): RColor =
  result.red = c.red * intensity
  result.green = c.green * intensity
  result.blue = c.blue * intensity
  result.alpha = c.alpha

const
  w = 1000
  h = 1000
  x0 = w div 2
  y0 = h div 2
  r = min(x0, y0) - 20
  r2 = r*r
  light = normalize((-30.0, -30.0, 50.0))
  ambient = 0.2
  k = 1.5
  colour = rgb(0, 255, 255)

var
  window = initRWindow()
    .size(w, h)
    .title("Rosetta Code - Draw a sphere")
    .open()
  surface = window.openGfx()
  canvas = window.newRCanvas()

var
  vec: Point
  d2: int
  intensity: float
  sumStep: float
  count: int

#surface.vsync = off
surface.loop:
  init ctx:
    ctx.renderTo(canvas):
      ctx.begin()
      for y in -r..r:
        for x in -r..r:
          d2 = x*x + y*y
          if d2 <= r2:
            vec = normalize((x.float, y.float, (r2-d2).float.sqrt))
            intensity = clamp((light.dot(vec).pow(k) + ambient)/(1+ambient), 0.0, 1.0)
            ctx.point(((x+x0).float, (y+y0).float, colour*intensity))
            #ctx.point(((x+x0).float, (y+y0).float, rgb(intensity, intensity, 1.0)))
      ctx.draw(prPoints)
  draw ctx, step:
    ctx.clear(gray(255))
    ctx.begin()
    ctx.texture = canvas
    ctx.rect(0, 0, surface.width, surface.height)
    ctx.draw()
    ctx.noTexture()
    sumStep += step
    count += 1
    if sumStep >= 12:
      echo count.float/sumStep * 60
      count = 0
      sumStep = 0
  update:
    discard
