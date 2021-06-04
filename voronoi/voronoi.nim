from math import `^`, pow
from os import paramCount, paramStr
from random import rand, randomize, sample
from sequtils import newSeqWith, toSeq
from strutils import parseEnum
from times import getTime, toUnix, nanosecond
import libgd

const
  img_width  = 640
  img_height = 480
  nSites = 150

type Metric = enum
  Euclid="euclid", Manhatten="manhatten", Minkowski="minkowski",
  Maximum="max", #Minimum="min",
  Hyperbel="hyperbel"

proc dot(x, y: int; metric: Metric): float =
  case metric
  of Euclid: float(x * x + y * y)
  of Manhatten: float(abs(x) + abs(y))
  of Minkowski: float(x * x * abs(x) + y * y * abs(y))
  of Hyperbel: pow(abs(x).float, 4/3) + pow(abs(y).float, 4/3)
  of Maximum: float(max(abs(x), abs(y)))
  #of Minimum: float(min(abs(x), abs(y)))

proc generateVoronoi(img: gdImagePtr; metric = Euclid) =
  # random sites
  let sx = newSeqWith(nSites, rand(2 ..< img_width-2))
  let sy = newSeqWith(nSites, rand(2 ..< img_height-2))
  #let sx = @[img_width div 2 - 50, img_width div 2 + 50, img_width div 2 - 130]
  #let sy = @[img_height div 2 - 50, img_height div 2 + 50, img_height div 2 + 130]

  # generate a random color for each site
  let sc = newSeqWith(nSites, img.setColor(rand(255), rand(255), rand(255)))

  # generate diagram by coloring each pixel with color of nearest site
  for x in 0 ..< img_width:
    for y in 0 ..< img_height:
      var dMin = float.high #dot(img_width, img_height)
      var sMin: seq[int]
      for s in 0 ..< nSites:
        if (let d = dot(sx[s] - x, sy[s] - y, metric); d) <= dMin:
          if d < dMin:
            (sMin, dMin) = (@[s], d)
          else:
            sMin.add s

      img.setPixel(point=[x, y], color=sc[sample(sMin)])
      #img.setPixel(point=[x, y], color=sc[sMin[(x + y) mod sMin.len]])
      #img.setPixel(point=[x, y], color=sc[sMin[(x div 2 + y div 2) mod sMin.len]])

  # mark each site with a black box
  let black = img.setColor(0x000000)
  for s in 0 ..< nSites:
    img.drawRectangle(
      startCorner=[sx[s] - 2, sy[s] - 2],
      endCorner=[sx[s] + 2, sy[s] + 2],
      color=black,
      fill=true)

proc main() =
  var metrics: seq[Metric] =
    if paramCount() > 0:
      @[parseEnum[Metric](paramStr(1))]
    else:
      toSeq(Metric.low .. Metric.high)

  let seed = (let now = getTime(); now.toUnix * 1000000000 + now.nanosecond)

  withGd imageCreate(img_width, img_height, trueColor=true) as img:
    for metric in metrics:
      randomize(seed)
      img.generateVoronoi(metric)

      let png_out = open("voronoi_diagram_" & $metric & ".png", fmWrite)
      img.writePng(png_out)
      png_out.close()

main()
