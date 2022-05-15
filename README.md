# GridInterpolator
Python library for a fast general-purpose, N-dimensional interpolation on regular grids.

## About
GridInterpolator is a Cython wrapper exposing public functions and classes of the [C++ library  btwxt (General-purpose, N-dimensional interpolation library) (ver. 0.2.0)](https://github.com/bigladder/btwxt).
GridInterpolator's source code is available on [GitHub](https://github.com/flabowski).

## About btwxt
> Btwxt is a free and open source c++ library to perform numerical interpolation on a gridded data set. The general architecture is that it creates a RegularGridInterpolator object from a) a collection of grid axes and b) a collection of values that fit that axis system. That RegularGridInterpolator object can then be queried repeatedly for values that fall inside its grid.
> Btwxt supports linear and cubic spline (Catmull-Rom) interpolation methods, and those methods can be specified independently for each axis. The API also allows specification of preferred extrapolation methods (constant or linear)--again independently for each axis--and extrapolation limits.
> The input grid is required to be regular (rectilinear) but the axes are not required to have uniform spacing. Each axis need only be strictly increasing.
> The values are imported as a long vector: a flattened array. It is your responsibility to ensure that you load the grid vectors in the same order as they are defined for the values. Btwxt ensures that the number of values aligns with the grid space, but it does not attempt to verify that the grid axis order is consistent with the values.
> Btwxt accepts:
> *   a collection of N vectors representing the input variables,
> *   attributes of each of the input vectors describing preferred interpolation and extrapolation methods, and
> *   an array of (or collection of arrays of) values that map onto the grid defined by the input vectors.

## Install
### TODO

## How to use
```
#TODO
```

## How to contribute


## Credits
* The btwxt library is written by [Big Ladder Software LLC](https://github.com/bigladder/btwxt)
* This project is based on [pyclipper](https://github.com/fonttools/pyclipper)

## License
* GridInterpolator is available under [MIT license](https://opensource.org/licenses/MIT)
* btwxt is available under [Big Ladder Software LLC`s license](https://github.com/bigladder/btwxt/blob/develop/LICENSE) 

