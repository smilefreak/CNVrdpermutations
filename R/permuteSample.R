#Exports functions we use in permutation MPI

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
