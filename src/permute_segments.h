#ifndef __PERMUTE_SEGMENTS__H_
#define __PERMUTE_SEGMENTS__H_
#include <Rcpp.h>
#include <omp.h>
//[[Rcpp::plugins(openmp)]]
#include "polyMorphicStretch.h"
#include "colSd.h"
#include <stdio.h>
#include <stdlib.h>
using namespace Rcpp;
#define CSTACK_DEFNS 7
#include <Rinterface.h>



void fisher_yates(int segment_lengths, int ** width_p, double ** mean_p, int * length_p);
double * get_standard_deviation(double **matrix, int list_length, int mat_size, double * standard_devs);
double * get_sample_row(double * means, int *widths, int en, int seg_number, double *standard_devs);
void get_permuted_matrix(int st, int en, int window_size, int *lengths, double **means, int **widths, int sample_number, double **mean_matrix, double *standard_devs);
// [[Rcpp::export]]
NumericMatrix permute_segmentation_results(List segmentResults, int window_size, int st, int en, int nperm);

#endif 
