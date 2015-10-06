#include <Rcpp.h>
#include "polyMorphicStretch.cpp"
#include "colSd.cpp"
#include <stdio.h>
#include <stdlib.h>

using namespace Rcpp;

/**
 * Function shuffles a segmented matrix n number of times
 * and calculates the standard devation for now.
 *
 * @author James Boocock
 * @date 6/10/2015
 * @return a
 *
 *
 **/

List fisher_yates(List segmentResults){
    srand(time(NULL));
    int segment_index = 0;
    int segment_length = segment_Results.size();
    RCout << "Running the cout function \n";
    for(segment_index = 0; segment_index < (segment_length - 1); segment_index++){
        j = rand() % segment_length + segment_length
        segmentResults[j] = segmentResults[i]       
    } 
    return segmentResults
}

// [Rcpp::export]]
standard_deviations permute_segmentation_results(List segmentResults, int window_size, int st, int en, int nperm){
   /**
    * First things first, we need to fisher yates,
    * the segmentResults. 
    *
    * TO DO implement all the functions in this file.
    */
    int i;
    NumericMatrix permuted_results;  
    NumericMatrix standard_deviations; 
    for(i = 0; i < nperm; i++){
        Rcout << "Permutation = " << i + 1 << "\n";
        segmentResults = fisher_yates(segmentResults);
        permuted_matrix = get_permuted_matrix(segmentResults);
        standard_deviations[i,] = colSd(permuted_matrix) 
    }
    return(standard_deviations);
}


