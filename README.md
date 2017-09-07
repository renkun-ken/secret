# secret

Make Secret Functions in package

To hide the source code of R functions in package, take the following steps:

1. Call `devtools::use_rcpp()` to initiate using Rcpp in package.
1. Call `secret::use_secret()` to initiate using secret in package.
1. Write anonymous functions in `./secret`.

    For example, create `./secret/test.R`:

    ```r
    function(x) {
      x + 100
    }
    ```
1. Call `secret::build_secret()` which converts all R scripts in `./secret` to corresponding C++ source files in `./src`. In the example, `./secret/test.R` is converted to `./src/test.cpp`.
1. Build and distribute the package in binary format.
