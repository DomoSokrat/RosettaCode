import locks, os, random, threadpool
randomize()
 
type Philosopher = ref object
  name: string
  food: string
  forkLeft, forkRight: int
 
const
  n = 5
  names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell"]
  foods = [" rat poison", " cockroaches", " dog food", " lemon-curd toast", " baked worms"]
  scale = 500
 
var
  forks: array[n, Lock]
 
proc run(p: Philosopher) =
  let
    fork1 = min(p.forkLeft, p.forkRight)
    fork2 = max(p.forkLeft, p.forkRight)

  while true:
    sleep rand(1..20) * scale
    echo p.name, " is hungry."
   
    acquire forks[fork1]
    sleep rand(1..5) * scale
    acquire forks[fork2]
   
    echo p.name, " starts eating", p.food, "."
    sleep rand(1..10) * scale
   
    echo p.name, " finishes eating", p.food, " and leaves to think."
   
    release forks[p.forkLeft]
    release forks[p.forkRight]
 
for i, name in names:
  initLock forks[i]
  let p = Philosopher(
    name: name,
    food: foods.sample,
    forkLeft: i,
    forkRight: (i + 1) mod n
  )
  spawn run(p)

sync()
