import random

import rapid/gfx

var
  window = initRWindow()
    .title("Rosetta Code - Chaos Game")
    .open()
  surface = window.openGfx()
  sierpinski = window.newRCanvas()
  points: array[3, Vec2[float]]

for i in 0..<3:
  points[i] = vec2(cos(PI * 2 / 3 * i.float), sin(PI * 2 / 3 * i.float)) * 300

var point = vec2(rand(0.0..surface.width), rand(0.0..surface.height))

var
  times: array[50, float]
  counter = 0

surface.vsync = true
surface.loop:
  draw ctx, step:
    times[counter] = RUpdateFreq/step
    echo times[counter], " ", min(times), " ", max(times)
    counter = (counter+1) mod times.len
    let vertex = sample(points)
    point = (point + vertex) / 2
    ctx.renderTo(sierpinski):
      ctx.transform():
        ctx.translate(surface.width / 2, surface.height * (1-sqrt(3.0)/4))
        ctx.rotate(-PI / 2)
        ctx.begin()
        ctx.point((point.x, point.y))
        ctx.draw(prPoints)
    ctx.clear(gray(0))
    ctx.begin()
    ctx.texture = sierpinski
    ctx.rect(0, 0, surface.width, surface.height)
    ctx.draw()
    ctx.noTexture()
  update:
    discard
