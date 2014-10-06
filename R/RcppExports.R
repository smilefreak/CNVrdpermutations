#Exports functions we use in permutation MPI

getSubRegionMatrixFromSegmentScores <- function(segmentResults, window_size, st, en) {
    .Call('generateSubRegions_getSubRegionMatrixFromSegmentScores', PACKAGE = 'generateSubRegions', segmentResults, window_size, st, en)
}

permuteChromosome <- function(task){
    chr  <- task[2]
    i <- task[1]
    st  <- task[3]
    en = task[4]
    windows  <- task[5]
    sample_list  <- sample_list_per_chromosome[[chr]]
    result <- lapply(sample_list,permuteSample,st=st,windows=windows)
    result <- list(segmentResults=result)
    polyMorphicResampling = getSubRegionMatrixFromSegmentScores(segmentResults=result$segmentResults,window_size = windows,st,en)
    return(list(i=i,chr=chr,result=polyMorphicResampling))
}

permuteSample <- function(segmentationResultsForSample,st,windows){
        ranks=seq(1,nrow(segmentationResultsForSample))
        reorder_ranks=sample(ranks,replace=F)
        segmentationResultsForSample = segmentationResultsForSample[reorder_ranks,]
        # Improve speed of this horrible for loop lol
        for( i in 1:nrow(segmentationResultsForSample)){
            dif = segmentationResultsForSample[i,4] - segmentationResultsForSample[i,3] + windows
            segmentationResultsForSample[i,3] = st
            segmentationResultsForSample[i,4] = st  + dif - windows
            st = st + dif
        }
        return(segmentationResultsForSample)
}
