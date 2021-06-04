from math import `^`, pow
from os import paramCount, paramStr
from random import rand, randomize, sample
from sequtils import newSeqWith, toSeq
from strutils import parseEnum
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

proc generateSites(): auto =
  # random sites
  newSeqWith(nSites, [rand(2 ..< img_width-2), rand(2 ..< img_width-2)])
  # testing sites
  #@[[img_width div 2 - 50, img_height div 2 - 50], [img_width div 2 + 50, img_width div 2 + 50], [img_width div 2 - 130, img_width div 2 + 130]]

proc generateColours(img: gdImagePtr): auto =
  # generate a random color for each site
  newSeqWith(nSites, img.setColor(rand(255), rand(255), rand(255)))

proc generateVoronoi(img: gdImagePtr; sites: seq[array[2, int]]; sc: seq[int]; metric = Euclid) =
  # generate diagram by coloring each pixel with color of nearest site
  for x in 0 ..< img_width:
    for y in 0 ..< img_height:
      var dMin = float.high
      var sMin: seq[int]
      for si, site in sites:
        if (let d = dot(site[0] - x, site[1] - y, metric); d) <= dMin:
          if d < dMin:
            (sMin, dMin) = (@[si], d)
          else:
            sMin.add si

      img.setPixel(point=[x, y], color=sc[sample(sMin)])
      #img.setPixel(point=[x, y], color=sc[sMin[(x + y) mod sMin.len]])
      #img.setPixel(point=[x, y], color=sc[sMin[(x div 2 + y div 2) mod sMin.len]])

  # mark each site with a black box
  let black = img.setColor(0x000000)
  for site in sites:
    img.drawRectangle(
      startCorner=[site[0] - 2, site[1] - 2],
      endCorner=[site[0] + 2, site[1] + 2],
      color=black,
      fill=true)

proc main() =
  randomize()
  var metrics: seq[Metric] =
    if paramCount() > 0:
      @[parseEnum[Metric](paramStr(1))]
    else:
      toSeq(Metric.low .. Metric.high)

  withGd imageCreate(img_width, img_height, trueColor=true) as img:
    let sites = generateSites()
    let colours = img.generateColours()
    for metric in metrics:
      img.generateVoronoi(sites, colours, metric)

      let png_out = open("voronoi_diagram_" & $metric & ".png", fmWrite)
      img.writePng(png_out)
      png_out.close()

main()
