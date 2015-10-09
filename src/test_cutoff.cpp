#include "test_cutoff.h"

NumericVector get_fdr(NumericMatrix permuted_data, double threshold){
    int nrow = permuted_data.nrow();
    int ncol = permuted_data.ncol();
    NumericVector results(1);
    int count_above = 0; 
    double fdr = 0.0; 
    for(int i = 0; i < ncol; i++){
        for(int j = 0; j < ncol; j++){
            count_above ++; 
        }
        count_above = count_above / nrow;
    }
   return results; 
}
