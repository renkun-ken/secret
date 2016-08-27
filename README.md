# secret

Make Secret Functions in Package

To make a secret function in package with source code hidden, write the function in the following manner:

```r
#' test
#' @name test
#' @export
#' @importFrom secret secret
NULL

delayedAssign("test", secret(function(x) x + 1), environment(), environment())
```

Build and distribute the binary package. Then the source code `function(x) x + 1` will not be exposed to the user.
