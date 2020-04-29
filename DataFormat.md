# PoSM Computer-Generated Data Format
## Input spec
### File name
Input files should be saved as: ```Title--Identifier.json```, where ```Title``` and ```Identifier```, both in ```UpperCamelCase```. ```Title``` is intended to reflect a specific model or specific piece of equipment, while ```Identifier``` corresponds to this particular set of parameters (see example below).

### File contents
```
{
    "description": "A sentence about what data these parameters will correspond to",
    "params": {
        "paramKey1": paramVal1,
        "paramKey2": paramVal2,
        ...
    },
}
```

The description should provide a brief explanation of what data the parameters correspond to.

```parameters``` includes any params needed to run the equipment or simulation. Units are dependent on the particular code being run.

## Data output spec
### File name
Two files, both titled ```Title--Identifier--yyyy-mm-dd--hh-mm-ss```, one with extension ```.json``` and one with extension ```.csv```. ```Title``` and ```Identifier``` are in ```UpperCamelCase``` and the timestamp (in UTC) is when execution of the program began. 

### Contents
```.json``` file:
```
{
    "description": "A sentence about what the data in this file is",
    "time": "yyyy-mm-dd--hh-mm-ss",
    "params": {
        "paramKey1": paramVal1,
        "paramKey2": paramVal2,
        ...
    },
    "numCols": int,
    "numRows": int,
    "project": {
        ...
    },
    "columns": [
        {
            "name": "Column1Name"
            "shortName: "Column1ShortName",
            "units": "Column1Units",
        },
        {
            "name": "Column2Name"
            "shortName: "Column2ShortName",
            "units": "Column2Units",
        },
        ...
    ],
}
```

```.csv``` file:
```
Column1ShortName,Column2ShortName,Column3ShortName, ...
x1,y1,z1, ...
x2,y2,z2, ...
```

#### .json file
The ```.json``` file is for metadata.

- ```time```: Timestamp (in UTC) of when the data collection began
- ```description```: Copy of description from input file
- ```params```: Copy of input file parameters
- ```numCols```: Number of columns in the data
- ```numRows```: Number of data points
- ```project```: Project-specific metadata (key must be present, but can be empty). For example, this might include the version of the code being run, the source of the data, or the time elapsed to run a simulation.
- ```columns```: Columns for each data point collected. ```ShortName``` can match ```Name```, or can be a shorter nickname (e.g. ```["Position", "x", "mm"]```). There must be ```numCols``` columns.

#### .csv file
The ```.csv``` file is for the data itself.

There must be exactly ```numRows``` lines of data, and each line must have ```numCols``` values, in the order presented in the ```columns``` metadata. There is no requirement that this data is in any particular order (i.e. switching any two lines is ok).

## Example files
### Input
File name: ```SprLatchKE--MasslessLatch01.json```

File contents:
```
{
    "description": "Simulates the kinetic energy of a projectile in a spring-latch system with const unlatching force",
    "metadata": {
        "params": {
            "m": 5,
            "m_l": 0.0,
            "F_l": 2,
            "k": 0.5,
        },
    },
},
```

### Output
File name: ```SprLatchKE--MasslessLatch01--2020-04-23--02-26-36.json```

File contents:
```
{
    "description": "Simulates the kinetic energy of a projectile in a spring-latch system with const unlatching force",
    "time": "2020-04-23--02-26-36",
    "params": {
        "m": 5,
        "m_l": 0.0,
        "F_l": 2,
        "k": 0.5,
    },
    "numCols": 4,
    "numRows": 3,
    "project": {
    },
    "columns": [
        {
            "name": "time"
            "shortName: "t",
            "units": "s",
        },
        {
            "name": "position"
            "shortName: "x",
            "units": "mm",
        },
        {
            "name": "velocity"
            "shortName: "v",
            "units": "m/s",
        },
        {
            "name": "kinetic energy"
            "shortName: "KE",
            "units": "mJ",
        },
    ],
}
```

File name: ```SprLatchKE--MasslessLatch01--2020-04-23--02-26-36.csv```

File contents:
```
t,x,v,KE
0 0 0 0
1 500 0.1 2
2 750 0.25 1
```