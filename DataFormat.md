# PoSM Computer-Generated Data Format
## Data output spec
### File name
```Title--yyyy-mm-dd--hh-mm-ss.json```, where ```Title``` is in ```UpperCamelCase``` and the timestamp is in UTC.

### Contents
```
[
    {
        "description": "A sentence about what the data in this file is"
    },
    {
        "metadata": {
            "time": "yyyy-mm-dd--hh-mm-ss",
            "params": {
                "paramKey1": paramVal1,
                "paramKey2": paramVal2,
                ...
            },
            "paramUnits": {
                "paramKey1": "unit1",
                "paramKey2": "unit2",
                ...
            }
            "numCols": int,
            "numRows": int,
            "project": {
                ...
            },
            "columns": [
                [Column1Name, Column1ShortName, Column1Units],
                [Column2Name, Column2ShortName, Column2Units],
                ...
            ],
        },
    },
    {
        "data": [
            [x1, y1, z1, ...],
            [x2, y2, z2, ...],
            ...
        ],
    },
]
```

#### Description
```description``` should give a brief explanation of what data the file following it contains.

#### Metadata
- ```time```: Timestamp (in UTC) of when the data collection began
- ```params```: Relevant paramters required for re-running the instrument or simulation. Units are dependent on the particular code being run.
- ```numCols```: Number of columns in the data
- ```numRows```: Number of data points
- ```project```: Project-specific metadata (key must be present, but can be empty). For example, this might include the version of the code being run, the source of the data, or the time elapsed to run a simulation.
- ```columns```: Columns for each data point collected. ```ShortName``` can match ```Name```, or can be a shorter nickname (e.g. ```["Position", "x", "mm"]```). Must be ```numCols``` columns.

#### Data
An array, where each entry is one row of data. There must be exactly ```numRows``` of data, and each row must have ```numCols``` values, in the order presented in the ```columns``` metadata. There is no requirement that this data is in any particular order (switching any two rows of data is ok).

## Input spec
### File name
All data should be saved as: ```Title--Identifier.json```, where ```Title``` is in ```UpperCamelCase```. The identifier has no constraints, but is recommended to have some human-understandable meaning (see example, below).

### File contents
```
[
    {
        "description": "A sentence about what the data in this file is"
    },
    {
        "metadata": {
            "params": {
                "paramKey1": paramVal1,
                "paramKey2": paramVal2,
                ...
            },
        },
    },
]
```

This matches the description and params from file output.


## Example files
### Input
File name: ```SprLatchKE-MasslessLatch01.json```

File contents:
```
[
    {
        "description": "Simulates the kinetic energy of a projectile in a spring-latch system with const unlatching force"
    },
    {
        "metadata": {
            "params": {
                "m": 5,
                "m_l": 0.0,
                "F_l": 2,
                "k": 0.5,
            },
        },
    },
]
```

### Output
File name: ```SprLatchKE--2020-04-23--02-26-36.json```

File contents:
```
[
    {
        "description": "Simulates the kinetic energy of a projectile in a spring-latch system with const unlatching force"
    },
    {
        "metadata": {
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
                ["time", "t", "s"],
                ["position", "x", "\u03bcm"],
                ["velocity", "v", "m/s"],
                ["kinetic energy", "KE", "mJ"],
            ],
        },
    },
    {
        "data": [
            [0, 0, 0, 0],
            [1, 500, 0.1, 2],
            [2, 750, 0.25, 1],
        ],
    },
]
```

Note that ```\u03bc``` is the UTF-8 encoding of mu.

## Justification for this spec
- It's super easy to read ```.json``` files using libraries other people have made. e.g. It's a whole [_one line_ in Python.](https://www.geeksforgeeks.org/read-json-file-using-python/)
- We can easily add more fields later. Adding more fields doesn't mess up any code already written using a previous version of this spec.
- It's super easy to send json files through http requests, if ever needed.
- With a web browser plugin or extension for your text editor, you can beautify the file to make it decently human-readable.