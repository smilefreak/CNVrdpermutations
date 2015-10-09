#ifndef __TEST_CUTOFF_H__
#define __TEST_CUTOFF_H__
#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector get_fdr(NumericMatrix permuted_data, double threshold);
#endif
