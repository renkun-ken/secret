#include "HideString.h"
#include <Rcpp.h>
using namespace Rcpp;

DEFINE_HIDDEN_STRING(Secret, 0x2f, (' '))

ExpressionVector SECRET_EXPR_SECRET_NAME(GetSecret());
Function SECRET_FUNCTION_SECRET_NAME = SECRET_EXPR_SECRET_NAME.eval();

// [[Rcpp::export]]
SEXP SECRET_NAME(SEXP& x)
{
  return SECRET_FUNCTION_SECRET_NAME(x);
}
