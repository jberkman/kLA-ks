# kLA-ks
kLA: Kerbal Linear Algebra

This library attempts to bring basic linear algebra functionality to kOS scripts. It provides several functions that should be familiar to people with experience using tools such as Matlab. While attempts will be made to keep code accurate and performant, I am not an expert in this field.

## Creating Matrices

Although kLA matrices are currently stored using kOS `List`s, they should be considered opaque data types and values should only be accessed using library functions.

### Zero Matrix

Usage:
```
klaZeros(m[, n])
```
Creates an *m* x *n* (or *m* x *m*) matrix filled with the value 0.

Example:
```
klaZeros(2, 3). // [ 0 0 0; 0 0 0 ]
```

### Ones Matrix

Usage:
```
klaOnes(m[, n])
```
Creates an *m* x *n* (or *m* x *m*) matrix filled with the value 1.

Example:
```
klaOnes(3, 2). // [ 1 1; 1 1; 1 1 ]
```

### Identity Matrix

Usage:
```
klaEye(n)
```
Creates an *n* x *n* matrix with the value 1 along the diagonal, and 0 elsewhere.

Example:
```
klaEye(3). // [ 1 0 0; 0 1 0; 0 0 1 ]
```

### List of Columns

Usage:
```
klaColumns(a)
```
Creates a matrix composed of the passed-in list of columns.

Example:
```
klaColumns(List(List(1, 2, 3), List(4, 5, 6), List(10, 12, 11))). [ 1 4 10; 2 5 12; 3 6 11 ]
```

### List of Rows

Usage:
```
klaRows(a)
```
Creates a matrix composed of the passed-in list of rows.

Example:
```
klaRows(List(List(1, 2, 2), List(-9, 17, 1.4))). [ 1 2 2; -9 17 1.4 ]
```

## Element Access

### Get Element

Usage:
```
klaGet(a, i, j)
```
Returns the value in the *i*th row and *j*th column (**1-indexed**) of matrix *a*.

Example:
```
klaGet(klaEye(3), 2, 2). // returns 1
```

### Set Element

Usage:
```
klaSet(a, i, j, v)
```
Sets the value of the *i*th row and *j*th column (**1-indexed**) of matrix *a* to *v*.

Example:
```
klaSet(klaZeros(3, 3), 2, 2, 5). // sets middle value to 5
```

## Matrix Properties

### Dimensions

Usage:
```
klaSize(a)
```
Returns a `List` of length 2 containing the height and width of *a*.

Example:
```
klaSize(klaZeros(2, 6))[0]. // returns 2
klaSize(klaZeros(2, 6))[1]. // returns 6
```

### Norm

Usage:
```
klaNorm(a)
```
Returns the Euclidean norm (2-norm) of matrix *a*.

Example:
```
klaNorm(klaEye(4)). // returns 2
```

### L-Norm

Usage:
```
klaLNorm(a, l)
```
Returns the *l*-norm of matrix *a*.

Example:
```
klaLNorm(klaEye(4), 1). // returns 4
```

## Matrix Operations

### Transpose

Usage:
```
klaTranspose(a)
```
Transposes matrix *a*.

Example:
```
klaTranspose(klaColumns(List(List(1, 1, 1))). // returns the row-vector [ 1 1 1 ]
```

### Normalization

Usage:
```
klaNormalize(a)
```
Divides each element of *a* by *a*'s norm.

Example:
```
klaNormalize(klaOnes(2, 2)). // [ .5 .5; .5 .5 ]
```

### Matrix-Matrix Sum

Usage:
```
klaSum(a, b)
```
Returns the matrix where each element is the sum of the corresponding elements in *a* and *b*.

Example:
```
klaSum(klaOnes(3), klaEye(3)). // [ 2 1 1; 1 2 1; 1 1 2 ]
```

### Scalar-Matrix Product

Usage:
```
klaSProd(s, a)
```
Returns the elements in *a* multipled by *s*.

Example:
```
klaSProd(3.14, klaEye(3)). // [ 3.14 0 0; 0 3.14 0; 0 0 3.14 ]
```

### Matrix-Matrix Product

Usage:
```
klaMProd(a, b)
```
Returns the product of matrix multiplication between *a* and *b*.

Example:
```
klaMProd(klaOnes(2, 3), klaOnes(3, 2)). // [ 3 3; 3 3 ]
```

## Decomposition and Least Squares

### QR Decomposition

Usage:
```
klaQRDecompose(a)
```
Returns the QR decomposition of *a*, such that `klaMProd(q, r)` equals *a*, and *q* provides an orthonormal basis for the range of *a*.

Example:
```
// [ 1 -1 4; 1 4 -2; 1 4 2; 1 -1 0 ]
local qr is klaQRDecompose(klaColumns(List(List(1, 1, 1, 1 ), List(-1, 4, 4, -1), List(4, -2, 2, 0))).
qr[0] // q: [ .5 -.5 .5; .5 .5 -.5; .5 .5 .5; .5 -.5 -.5 ]
qr[1] // r: [ 2 3 2; 0 5 -2; 0 0 4 ]
```

### Least-Squares Approximation

Usage:
```
klaBackslash(a, b)
```
Returns the solution to *ax* = *b*, namely `inv(*a*)` * *b*.

Example:
```
local a is klaRows(List(List(2, 0), List(-1, 1), List(0, 2))).
local b is klaColumns(List(List(1, 0, -1))).
klaBackslash(a, b). // [ 0.3333; -0.3333 ]
```

## Miscellaneous

### Printing to Console

Usage:
```
klaPrint(a)
```
Prints a matrix to the console.

Example:
```
klaPrint(klaEye(3)).
```
