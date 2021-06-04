import strutils

type
  Direction = enum up, right, down, left
  Color = enum white = " ", black = "#"

const
  width = 49
  height = 59

var
  m: array[height, array[width, Color]]
  dir = left
  x = width div 2
  y = height div 2 + 1

func rightTurn(dir: var Direction) =
  if dir == left:
    dir = up
  else:
    inc dir

func leftTurn(dir: var Direction) =
  if dir == up:
    dir = left
  else:
    dec dir

var i = 0
while x in 0 ..< width and y in 0 ..< height:
  let turn_right = m[y][x] == white
  m[y][x] = if m[y][x] == black: white else: black

  if turn_right: rightTurn(dir)
  else: leftTurn(dir)

  case dir
  of up:    dec y
  of right: inc x
  of down:  inc y
  of left:  dec x

  inc i

  stdout.write "\e[H"
  for row in m:
    echo row.join("")

echo i
