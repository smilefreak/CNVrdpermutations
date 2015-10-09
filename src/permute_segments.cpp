#include "permute_segments.h"


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

void fisher_yates(int segment_length, int ** width_p, double ** mean_p, int * length_p){
    /**
     * Performs a fisher yates shuffle of the mean and widths
     *
     **/
    //Rcout << "Running a fisher_yates_shuffle \n";
    int j;
    double **means = mean_p;
    int **widths = width_p;
    int *lengths = length_p;
    for(int i = 0; i < segment_length; i++){
        int row_num = lengths[i];
        for(int segment_index = (row_num - 1); segment_index > 0; segment_index--){
            j = rand() % (segment_index+1);
            widths[i][j] = widths[i][segment_index];
            means[i][j] = means[i][segment_index]; 
            //segmentResults[j] = segmentResults[segment_index];
        }
    }
}

double * get_sample_row(double *means, int *widths, int en, int seg_number, double * standard_devs){ 
    //Rcout << "In sample row" << "\n";
    int random_start = (rand() % (en/1000)); 
    for (int i = 0;  i < seg_number; i++){
        int tmp_width = widths[i] /1000;
        while(tmp_width > 0){
            if(random_start > en/1000){
            //    Rcout << "Do we actually wrap aronud ???" << random_start << "\n"; 
                random_start = 0;
            } 
            standard_devs[random_start++] = means[i];     
            //Rcout << standard_devs[random_start- 1]<< "\n"; 
            tmp_width--;
        } 
    }
    return standard_devs;
} 

double * get_standard_deviation(double **mean_matrix, int list_length, int mat_size, double * standard_devs){
    for(int i =0; i < mat_size; i++){
        double mean = 0.0;
        double M2 = 0.0;
        int n = 0;
        double delta;
        double x;
        for(int j=0; j < list_length; j++){
            n++;
            x = mean_matrix[j][i];
            delta = x - mean;
            mean = mean + delta/n;
            M2 = M2 + delta*(x-mean);
        }
        //ncout << "In the standard deviation Loop" << "\n";
        standard_devs[i] = M2 / (n - 1);
    }
    return standard_devs;
}

void get_permuted_matrix(int st, int en, int window_size, int *lengths, double **means, int ** widths, int sample_number, double ** mean_matrix, double * standard_devs){
    /**
     *
     * get_permutated_matrix takes the list of segments Fisher Yates each sample and regenerates a large matrix. 
     *
     * @author James Boocock
     */
    int mat_size = en/1000;
    fisher_yates(sample_number, widths, means, lengths);

    // Let's populate the matrix so that we can perform standard
    for(int i = 0; i < sample_number; i++){
        // standard devs is used for temp storage
        double * sample_row =  get_sample_row(means[i], widths[i], en, lengths[i], standard_devs);
        for(int j = 0; j < mat_size; j++){
            mean_matrix[i][j] = sample_row[i];
        }
    }
    get_standard_deviation(mean_matrix, sample_number, mat_size, standard_devs);
    // clean up allocated memory
}

NumericMatrix permute_segmentation_results(List segmentResults, int window_size, int st, int en, int nperm){
    /**
     * Fisher yates function for interfacting with R. Takes CNVrd2s 
     * segment results and outputs a NumericMatrix
     */
    int list_length = segmentResults.size();
    int mat_size = en/1000;
    NumericMatrix permuted_matrix(nperm, mat_size);  
    NumericVector starts;
    NumericVector ends;
    NumericVector lengths_vec;
    NumericVector seg_means;
    // hopefully this should extract everythin we need for further processing
    DataFrame temp_df;
    int **widths = new int*[list_length];
    double **means =new double*[list_length];
    int *lengths = new int[list_length];
    for(int i = 0; i < list_length; i++){
        temp_df = as<DataFrame>(segmentResults[i]);
        starts = temp_df["loc.start"];
        ends = temp_df["loc.end"];
        lengths_vec = ends - starts;
        seg_means = temp_df["seg.mean"];
        //Rcout << "Can We extract a data.frame from a list" << "\n";
        int row_num = seg_means.size();
        widths[i] = new int[row_num];
        means[i] = new double[row_num];
        lengths[i] = row_num;
        //Rcout << "Row nums : " << row_num <<"\n";
        for(int k = 0; k < row_num; k++){
            widths[i][k] = (int) lengths_vec[k];
            means[i][k] = seg_means[k];
            //Rcout << widths[i][k] << "\n";  
        }
    }
    R_CStackLimit=(uintptr_t)-1;
    omp_set_num_threads(10);
    setenv("OMP_STACKSIZE","XM",100000);
#pragma omp parallel
    {
        double *standard_devs = 0;
        double **mean_matrix = 0;
        standard_devs = new double[mat_size];
        mean_matrix = new double*[list_length];
        for (int i = 0; i < list_length; i++){
            mean_matrix[i]=new double[mat_size];
        } 
       #pragma omp for
        for(int i = 0; i < nperm; i++){
            Rcout << "Permutation = " << i + 1 << "\n";
            //segmentResults = fisher_yates(segmentResults)
            //
            get_permuted_matrix(st, en, window_size, lengths, means, widths, list_length, mean_matrix, standard_devs);
            for(int j = 0; j < mat_size; j++){
//                Rcout << standard_devs[j] << "\n";
                permuted_matrix(i,j) = standard_devs[j];
            } 
        }
    }
    return(permuted_matrix);
}






