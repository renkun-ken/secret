#include <Rcpp.h>
using namespace Rcpp;

ExpressionVector secret_expr_SECRET_NAME("SECRET_CODE");
Function secret_fun_SECRET_NAME = secret_expr_SECRET_NAME.eval();

// [[Rcpp::export]]
SEXP SECRET_NAME(SEXP x)
{
  return secret_fun_SECRET_NAME(x);
}
