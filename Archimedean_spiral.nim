import math
#import os

import gintro/[glib, gobject, gtk, gio, cairo]

const

  Width = 601
  Height = 601

  Limit = 12 * math.PI

  Origin = (x: float(Width div 2), y: float(Height div 2))
  B = floor((Width div 2) / Limit)

#-------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
  ## Draw the spiral.

  var theta = 0.0
  var delta = 0.01

  # Clear the region.
  context.moveTo(0, 0)
  context.setSource(0.0, 0.0, 0.0)
  context.paint()

  # Draw the spiral.
  context.setSource(1.0, 1.0, 0.0)
  context.moveTo(Origin.x, Origin.y)
  while theta < Limit:
    let r = B * theta
    let x = Origin.x + r * cos(theta)   # X-coordinate on drawing area.
    let y = Origin.y + r * sin(theta)   # Y-coordinate on drawing area.
    context.lineTo(x, y)
    context.stroke()
    # Set data for next round.
    context.moveTo(x, y)
    theta += delta
    #while gtk.eventsPending(): discard gtk.mainIteration()
    #sleep 10
  #type argType = tuple[context: Context, ox, oy, B, delta, theta, prevX, prevY: float]
  #proc drawLoop(data: pointer): gboolean {.cdecl.} =
  #  var d = cast[ptr argType](data)
  #  if d.theta < Limit:
  #    let r = d.B * d.theta
  #    let x = d.ox + r * cos(d.theta)   # X-coordinate on drawing area.
  #    let y = d.oy + r * sin(d.theta)   # Y-coordinate on drawing area.
  #    echo d.prevX," ",d.prevY
  #    echo x," ",y
  #    d.context.moveTo(d.prevX, d.prevY)
  #    d.context.lineTo(x, y)
  #    d.context.stroke()
  #    d.theta += d.delta
  #    d.prevX = x
  #    d.prevY = y
  #    discard glib.timeout_add(PRIORITY_DEFAULT, 10, drawLoop, data, nil)
  #  else:
  #    echo "done"
  #    d.context.moveTo(10, 10)
  #    d.context.lineTo(100, 100)
  #    d.context.stroke()
  #    dealloc(data)
  #var data = create(argType)
  #data[] = (context, Origin.x, Origin.y, B, delta, Limit/2, Origin.x, Origin.y)
  #discard drawLoop(data)

#-------------------------------------------------------------------------------

proc onDraw(area: DrawingArea; context: Context; data: pointer): bool =
  ## Callback to draw/redraw the drawing area contents.

  area.draw(context)
  result = true

#-------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(Width, Height)
  window.setTitle("Archimedean spiral")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the spiral.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#-------------------------------------------------------------------------------

let app = newApplication(Application, "Rosetta.spiral")
discard app.connect("activate", activate)
discard app.run()
