import locks, os, random
randomize()
 
type Philosopher = ref object
  name: string
  food: string
  forkLeft, forkRight: int
 
const
  n = 2
  names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell", "Wittgenstein", "Adorno", "Popper"]
  foods = [" rat poison", " cockroaches", " dog food", " lemon-curd toast", " baked worms", " durians", " surstoeming", " baby seals"]
  scale = 500
 
assert names.len >= n
assert foods.len >= n

var
  forks: array[n, Lock]
  threads: array[n, Thread[Philosopher]]
 
proc run(p: Philosopher) =
  let
    fork1 = min(p.forkLeft, p.forkRight)
    fork2 = max(p.forkLeft, p.forkRight)

  while true:
    sleep rand(1..20) * scale
    echo p.name, " is hungry."
   
    acquire forks[fork1]
    sleep rand(0..2) * scale div 2
    acquire forks[fork2]
   
    echo p.name, " starts eating", p.food, "."
    sleep rand(1..10) * scale
   
    echo p.name, " finishes eating", p.food, " and leaves to think."
   
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
  createThread(threads[i], run, p)

joinThreads(threads)
