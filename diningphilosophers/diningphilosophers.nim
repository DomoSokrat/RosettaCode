import locks, os, random, threadpool, times
randomize()
 
type Philosopher = ref object
  name: string
  food: string
  forkLeft, forkRight: int
 
const
  n = 8
  names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell", "Wittgenstein", "Adorno", "Popper"]
  foods = [" rat poison", " cockroaches", " dog food", " lemon-curd toast", " baked worms", " durians", " surstoeming", " baby seals"]
  scale = 500
 
assert names.len >= n
assert foods.len >= n

var
  forks: array[n, Lock]
 
template log(msgs: varargs[untyped]): untyped =
  echo getTime().format("ss'.'fff': '"), msgs

proc run(p: Philosopher) =
  let
    fork1 = min(p.forkLeft, p.forkRight)
    fork2 = max(p.forkLeft, p.forkRight)
  var
    cycle = 0
    t: Time

  while true:
    sleep rand(1..20) * scale
    inc cycle
    log p.name, " is hungry. cycle: ", cycle
   
    t = getTime()
    acquire forks[fork1]
    log p.name, " got fork1 after ", (getTime()-t).inMilliseconds
    sleep rand(1..5) * scale
    t = getTime()
    log p.name, " got fork2 after ", (getTime()-t).inMilliseconds
    acquire forks[fork2]
   
    log p.name, " starts eating", p.food, "."
    sleep rand(1..10) * scale
   
    log p.name, " finishes eating", p.food, " and leaves to think."
   
    release forks[p.forkLeft]
    release forks[p.forkRight]
 
for i in 0 ..< n:
  initLock forks[i]
  let p = Philosopher(
    name: names[i],
    food: foods.sample,
    forkLeft: i,
    forkRight: (i + 1) mod n
  )
  spawn run(p)

sync()
