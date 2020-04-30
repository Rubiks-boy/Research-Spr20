# Frictional Latch ODE Solver
## What does this do?
This simulates a model of a spring-latch system where there is friction between a rounded latch and a projectile.

This numerically solves the differential equation located at ```../Friction between latch, proj/derivations.pdf```, equation (12). It uses the data spec located at the root of this repository: ```DataFormat.md```.

## How do I use it?
**Compiling:** You must have [odeint](https://headmyshoulder.github.io/odeint-v2/) installed. On a mac, this can be done using Homebrew: ```brew install odeint```. 

Make the file by calling ```make``` from your terminal.

**Running It:** Run by calling ```./bin/release/main <filename>``` or ```./bin/release <filename1> <filename2> ...```. Two example parameters files are located in the params folder and can be run using ```./bin/release/main params/I-*.json```. This will create two output files, a ```.json``` and a ```.csv```, according to the data output spec. These two files will be in the same directory alongside the input files.

Input files must include a description and six parameters that are all floats:
1. ```m```: Mass of projectile
2. ```m_l```: Mass of the latch
3. ```F_l```: Force pulling the latch
4. ```F_spr```: Force of the spring
5. ```r```: Radius of the rounded latch
6. ```mu```: Frictional coefficient between the latch and the projectile.

For example,
```
{
    "description": "Simulates the kinetic energy of a projectile in a spring-latch system with const unlatching force",
    "params": {
        "m": 1,
        "m_l": 0.1,
        "F_l": 1,
        "F_spr": 1,
        "r": 1,
        "mu": 0.2
    }
 }
 ```

## What's missing?
- Spring force probably shouldn't be a constant.
- No data validation: It trusts that all the ```.json``` files you give it are formatted correctly, and it trusts it has read/write access to that directory.
- Error messages not only aren't verbose – they, in most cases, don't exist. You _should_ get an error message if it's reading/writing a file-related, but outside of that, you're probably out of luck. :/