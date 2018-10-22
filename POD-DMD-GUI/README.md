# POD-DMD GUI

To run the GUI, type in the Matlab command line: `Main_MENU`

## Datasets for the GUI

The matrix `D` with the variable of interest have to have a dimension `(m x n)`, where `m` represents spacial discretization and `n` represents variable observations.

```
   observations
s [		]
p [		]
a [	D	]
c [		]
e [		]

```

### 1D Scalar

Provide matrix `D` in the above mentioned format and a vector `y` specifying the 1-dimensional space discretization.

*Example dataset: `Pressure(x)`*

### 2D Scalar

Provide matrix `D` in the above mentioned format and two vectors `X`, `Y` specifying the 2-dimensional space discretization.

*Example dataset: `Pressure(x,y)`*

### 2D Vector

Provide two matrices `U` and `V` in the above mentioned format and two vectors `X`, `Y` specifying the 2-dimensional space discretization.

*Example dataset: `Velocity(x,y)`*

## Code hierarchy

```
Main_MENU
	POD_OR_DMD
		POD_DMD_beta_1
		* Import Data
		* Decompose
		* Export Results
		* Exit
```

### `Main_MENU`

Allows to chose type type of dataset from:

```
1D Scalar
2D Scalar
2D Vector
```

### `POD_OR_DMD`

Allows to chose decomposition method from:

```
POD (Proper Orthogonal Decomposition)
DMD (Dynamic Mode Decomposition)
```

### `POD_DMD_beta_1`

Allows to import data, perform the decomposition and export the results.

