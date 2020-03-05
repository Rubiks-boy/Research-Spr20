Accepts parameters for a spring-latch system with a heavy spring & rounded latch with some unlatching time t_l.

Week following 30 Jan:
- Derived equations to describe prior to unlatching, between unlatching and taking off, and after takeoff.
- Made a first attempt at coding it up in Matlab. This became a nightmare to debug; there appears to be a lot wrong with it, and a function-driven approach made debugging difficult. 
- Plan for next week: code one small part at a time, and debug as I go.

Week following 6 Feb:
- Restarted on code
- Got charts for x, v, and a (z axis) w/r/t m (x axis) and t (y axis)
- Began working on an accel. vs. vel. and pos. chart. Most regions on this chart weren't filled in b/c we were evaluating at a set range of times

Week following 15 Feb:
- Separated much of the code into functions
- Time range for evaluating x, v, and a is now based on [(unlatching time) + (takeoff time)] * (some set percentage).

Week following 20 Feb:
- Separated "Heavy spr, rounded latch, const F" folder into an outer layer inteface, and a results file that does most of the calculations
- All plotting occurs in outer layer
- Ran out_1 and out_2, which mimic the results found in supplemental text

Week following 27 Feb:
- Fixed bug with fzero / imaginary values; Only runs fzero for finding t_l if we're less than philir velocity (philir.pdf)